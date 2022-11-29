import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;
import '../models/area_folders.dart';
import '../models/area.dart';
import '../models/channel.dart';
import '../models/preset.dart';
import '../Services/dynet.dart';

class AreaData extends ChangeNotifier {
  String _gatewayAddress = '';

  final List<AreaFolder> _folders = [];

  final List<Area> _favouriteAreas = [];

  final List<Area> _recentAreas = [];

  final List<Area> _frequentAreas = [];

  String get gatewayAddress {
    return _gatewayAddress;
  }

  List<AreaFolder> get folders {
    return [..._folders];
  }

  List<Area> get getFavouriteAreas {
    return _favouriteAreas;
  }

  List<Area> get getRecentAreas {
    try {
      return _recentAreas.reversed.toList().sublist(0, 4);
    } catch (e) {
      return _recentAreas;
    }
  }

  List<Area> get getFequentAreas {
    try {
      return _frequentAreas.sublist(0, 4);
    } catch (e) {
      return _frequentAreas;
    }
  }

  List<List<Area>> get allAreaLists {
    List<List<Area>> areaLists = [];

    for (AreaFolder folder in _folders) {
      areaLists.add(folder.areas);
    }

    return areaLists;
  }

  void _updateFolders(List<AreaFolder> areaFolders) {
    _clearAllAreas();
    _folders.addAll(areaFolders);
    _initialiseUserLists(areaFolders[0].areas);
  }

  void updateGatewayAddress(String address) {
    _gatewayAddress = address;
  }

  Future sendCurrentPreset(Area area, int preset) async {
    Dynet dynet = Dynet(gatewayAddress);
    area.setCurrentPreset(preset);
    notifyListeners();
    try {
      await dynet.setPreset(area: area.areaNumber, preset: preset);
      _addRecentArea(area);
    } catch (error) {
      area.setCurrentPreset(0);
      notifyListeners();
      rethrow;
    }
  }

  Future sendCurrentPresetName(Area area, String presetName) async {
    Dynet dynet = Dynet(gatewayAddress);
    area.setCurrentPresetName(presetName);
    notifyListeners();
    try {
      await dynet.setPreset(
          area: area.areaNumber, preset: area.areaCurrentPreset);
      _addRecentArea(area);
    } catch (error) {
      area.setCurrentPresetName('');
      notifyListeners();
      rethrow;
    }
  }

  Future sendCurrentChannelLevel(
      Area area, Channel channel, double level) async {
    Dynet dynet = Dynet(gatewayAddress);
    area.setCurrentChannelLevel(channel, level);
    notifyListeners();
    await dynet.setChannelLevel(
        area: area.areaNumber,
        channel: channel.channelNumber,
        level: level.toInt());
    _addRecentArea(area);
  }

  void setCurrentChannelLevel(Area area, Channel channel, double level) {
    area.setCurrentChannelLevel(channel, level);
    notifyListeners();
  }

  Future requestCurrentPreset(Area area) async {
    Dynet dynet = Dynet(gatewayAddress);
    String data;

    try {
      data = await dynet.requestCurrentPreset(area: area.areaNumber);
      area.setCurrentPreset(int.parse(data));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future requestCurrentChannelLevel(Area area, Channel channel) async {
    Dynet dynet = Dynet(gatewayAddress);
    String data;

    try {
      data = await dynet.requestCurrentChannelLevel(
          area: area.areaNumber, channelNumber: channel.channelNumber);
      area.setCurrentChannelLevel(channel, double.parse(data));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future requestAllChannelLevels(Area area) async {
    Dynet dynet = Dynet(gatewayAddress);
    String data;

    for (Channel channel in area.areaChannels) {
      try {
        await Future.delayed(const Duration(milliseconds: 200), () async {
          data = await dynet.requestCurrentChannelLevel(
              area: area.areaNumber, channelNumber: channel.channelNumber);
          area.setCurrentChannelLevel(channel, double.parse(data));
          notifyListeners();
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future requestListChannelLevels(Area area, List<Channel> channels) async {
    Dynet dynet = Dynet(gatewayAddress);
    String data;

    for (Channel channel in channels) {
      try {
        await Future.delayed(const Duration(milliseconds: 200), () async {
          data = await dynet.requestCurrentChannelLevel(
              area: area.areaNumber, channelNumber: channel.channelNumber);
          area.setCurrentChannelLevel(channel, double.parse(data));
          notifyListeners();
        });
      } catch (e) {
        print(e);
      }
    }
  }

  void _initialiseUserLists(List<Area> areaList) {
    _frequentAreas.addAll(areaList);
    _recentAreas.addAll(areaList.reversed.toList());
  }

  void addFavourite(Area area) {
    _favouriteAreas.add(area);
    notifyListeners();
  }

  void addPresetCard(Area area) {
    if (!isAreaFavourite(area)) {
      addFavourite(area);
      notifyListeners();
    }
  }

  void removePresetCard(Area area) {
    _favouriteAreas.removeWhere(
        (currentArea) => currentArea.areaNumber == area.areaNumber);
    notifyListeners();
  }

  void removeAllFavourites() {
    _favouriteAreas.clear();
    notifyListeners();
  }

  void _addRecentArea(Area area) {
    _recentAreas.removeWhere(
        (currentArea) => currentArea.areaNumber == area.areaNumber);

    _recentAreas.add(area);

    if (_recentAreas.length > 5) {
      _recentAreas.removeAt(0);
    }

    _addFrequentArea(area);
  }

  void _addFrequentArea(Area area) {
    ++area.timesUsed;

    _frequentAreas.removeWhere(
        (currentArea) => currentArea.areaNumber == area.areaNumber);

    _frequentAreas.add(area);

    _frequentAreas.sort((a, b) => b.timesUsed.compareTo(a.timesUsed));

    notifyListeners();
  }

  bool isAreaFavourite(Area area) {
    bool isFavourite = false;
    for (Area currentArea in _favouriteAreas) {
      if (currentArea.areaNumber == area.areaNumber) {
        isFavourite = true;
      }
    }

    return isFavourite;
  }

  void _clearAllAreas() {
    _folders.clear();
    _favouriteAreas.clear();
    _frequentAreas.clear();
    _recentAreas.clear();
  }

  String get areaDataEncoded {
    Map<String, dynamic> areaDataMap = {};
    for (AreaFolder folder in _folders) {
      if (!(_folders.length > 1 && folder.folderName == 'All Areas')) {
        Map<String, dynamic> areaMap = {};
        for (Area area in folder.areas) {
          Map<String, dynamic> presetMap = {};
          Map<String, dynamic> channelMap = {};
          for (Preset preset in area.areaPresets) {
            presetMap[preset.presetName] = preset.presetNumber;
          }
          for (Channel channel in area.areaChannels) {
            channelMap[channel.channelName] = channel.channelNumber;
          }
          areaMap[area.areaName] = {
            'areaNumber': area.areaNumber,
            'presets': presetMap,
            'channels': channelMap,
          };
        }
        areaDataMap[folder.folderName] = areaMap;
      }
    }

    return jsonEncode(areaDataMap);
  }

  List<AreaFolder> areaDataDecode(String areaJsonData) {
    final areaDataMap = jsonDecode(areaJsonData) as Map<String, dynamic>;
    List<AreaFolder> areaFolders = [];

    if (areaDataMap.keys.length > 1) {
      areaFolders.add(AreaFolder(folderName: 'All Areas', areas: []));
    }
    areaDataMap.forEach((folder, areas) {
      List<Area> areaList = [];
      (areas as Map<String, dynamic>).forEach((area, value) {
        List<Preset> presets = [];
        List<Channel> channels = [];

        (value['presets'] as Map<String, dynamic>).forEach((preset, value) {
          presets.add(Preset(
            presetName: preset,
            presetNumber: value,
          ));
        });

        (value['channels'] as Map<String, dynamic>).forEach((channel, value) {
          channels.add(Channel(
            channelName: channel,
            channelNumber: value,
          ));
        });

        final newArea = Area(
          areaName: area,
          areaNumber: value['areaNumber'],
          areaPresets: presets,
          areaChannels: channels,
          areaIcon: Area.assignAreaIcon(area),
        );
        if (areaDataMap.keys.length > 1) {
          areaFolders[0].areas.add(newArea);
        }
        areaList.add(newArea);
      });
      areaFolders.add(AreaFolder(folderName: folder, areas: areaList));
    });

    areaFolders[0].areas.sort((a, b) => a.areaNumber.compareTo(b.areaNumber));
    _updateFolders(areaFolders);
    notifyListeners();

    return areaFolders;
  }

  Future loadXmlFile(File file) async {
    // String xmlString =
    //     await rootBundle.loadString('assets/Logical.xml');
    String xmlString = await file.readAsString();
    var xmlData = xml.XmlDocument.parse(xmlString);

    _clearAllAreas();
    _folders.add(AreaFolder(folderName: 'All Areas', areas: []));

    xmlData.findAllElements('Folder').map((folder) {
      List<Area> areaList = folder
          .findElements('Area')
          .map((area) => Area(
                areaNumber: int.parse(area.getAttribute('id')!),
                areaName: area.getAttribute('name')!,
                areaPresets: _getXmlPresets(area),
                areaChannels: _getXmlChannels(area),
                areaIcon: Area.assignAreaIcon(area.getAttribute('name')!),
              ))
          .toList();

      _folders[0].areas.addAll(areaList);

      AreaFolder newFolder = AreaFolder(
        folderName: folder.getAttribute('id')!,
        areas: areaList,
      );

      return newFolder;
    }).forEach((newFolder) {
      if (newFolder.areas.isNotEmpty) {
        _folders.add(newFolder);
      }
    });

    if (_folders.length > 2) {
      List<Area> unassignedAreas = xmlData
          .findElements('LogicalExport')
          .first
          .findElements('Area')
          .map((area) => Area(
                areaNumber: int.parse(area.getAttribute('id')!),
                areaName: area.getAttribute('name')!,
                areaPresets: _getXmlPresets(area),
                areaChannels: _getXmlChannels(area),
                areaIcon: Area.assignAreaIcon(area.getAttribute('name')!),
              ))
          .toList();

      if (unassignedAreas.isNotEmpty) {
        _folders[0].areas.addAll(unassignedAreas);
        _folders.insert(
            1, AreaFolder(folderName: 'Unassigned', areas: unassignedAreas));
      }
    }

    if (_folders[0].areas.isEmpty) {
      _folders[0].areas.addAll(
            xmlData
                .findAllElements('Area')
                .map((area) => Area(
                      areaNumber: int.parse(area.getAttribute('id')!),
                      areaName: area.getAttribute('name')!,
                      areaPresets: _getXmlPresets(area),
                      areaChannels: _getXmlChannels(area),
                      areaIcon: Area.assignAreaIcon(area.getAttribute('name')!),
                    ))
                .toList(),
          );
    }

    _folders[0].areas.sort((a, b) => a.areaNumber.compareTo(b.areaNumber));

    _initialiseUserLists(_folders[0].areas);

    notifyListeners();
  }

  List<Channel> _getXmlChannels(xml.XmlElement area) {
    List<Channel> channelList = [
      Channel(channelNumber: 0, channelName: 'All Channels'),
    ];

    List<Channel> newChannels = area.findElements('Channel').map((channel) {
      Channel newChannel = Channel(
        channelNumber: int.parse(channel.getAttribute('id')!),
        channelName: channel.getAttribute('name')!,
      );

      return newChannel;
    }).toList();

    channelList.addAll(newChannels);

    return channelList;
  }

  List<Preset> _getXmlPresets(xml.XmlElement area) {
    return area.findElements('Preset').map((preset) {
      Preset newPreset = Preset(
        presetNumber: int.parse(preset.getAttribute('id')!),
        presetName: preset.getAttribute('name')!,
      );

      return newPreset;
    }).toList();
  }
}
