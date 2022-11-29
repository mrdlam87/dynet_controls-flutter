import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dynet_controls_v2/models/preset.dart';
import 'package:dynet_controls_v2/models/channel.dart';

class Area {
  Area({
    required this.areaNumber,
    required this.areaName,
    required this.areaPresets,
    required this.areaChannels,
    this.areaIcon,
    this.areaCurrentPreset = 0,
    this.areaCurrentPresetName = 'Off',
    this.timesUsed = 0,
  });

  int areaNumber;
  String areaName;
  IconData? areaIcon;
  int areaCurrentPreset;
  String areaCurrentPresetName;
  List<Preset> areaPresets = [];
  List<Channel> areaChannels = [
    Channel(channelNumber: 0, channelName: 'All Channels')
  ];
  int timesUsed;

  void setCurrentPreset(int presetNumber) {
    areaCurrentPreset = 0;
    for (Preset preset in areaPresets) {
      if (preset.presetNumber == presetNumber) {
        areaCurrentPreset = presetNumber;
        areaCurrentPresetName = preset.presetName;
      }
    }
  }

  void setCurrentPresetName(String presetName) {
    areaCurrentPreset = 0;
    for (Preset preset in areaPresets) {
      if (preset.presetName == presetName) {
        areaCurrentPresetName = presetName;
        areaCurrentPreset = preset.presetNumber;
      }
    }
  }

  void setCurrentChannelLevel(Channel channel, double channelLevel) {
    channel.setCurrentChannelLevel(channelLevel);
  }

  String get getAllChannelNames {
    String allChannelNames = '';

    for (Channel channel in areaChannels) {
      allChannelNames = allChannelNames + channel.channelName;
    }

    return allChannelNames;
  }

  static IconData assignAreaIcon(String name) {
    IconData areaIcon = Icons.lightbulb;

    Map<String, IconData> iconList = {
      'living': FontAwesomeIcons.couch,
      'dining': FontAwesome.food,
      'bed': FontAwesomeIcons.bed,
      'game': FontAwesome.gamepad,
      'external': FontAwesomeIcons.tree,
    };

    iconList.forEach((key, value) {
      if (name.toLowerCase().contains(key)) {
        areaIcon = value;
      }
    });

    return areaIcon;
  }
}
