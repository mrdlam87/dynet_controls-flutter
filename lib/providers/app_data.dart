import 'package:flutter/material.dart';
import '../models/area.dart';

class _AppData extends ChangeNotifier {

  final List<Area> _favouriteAreas = [];

  final List<Area> _recentAreas = [];

  final List<Area> _frequentAreas = [];


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

  void initialiseLists(List<Area> areaList) {
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

  void addRecentArea(Area area) {
    _recentAreas.removeWhere(
        (currentArea) => currentArea.areaNumber == area.areaNumber);

    _recentAreas.add(area);

    if (_recentAreas.length > 5) {
      _recentAreas.removeAt(0);
    }

    addFrequentArea(area);

    notifyListeners();
  }

  void addFrequentArea(Area area) {
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

  // int _tabIndex = 0;

  // int get getSelectedTabIndex {
  //   return _tabIndex;
  // }

  // void setTabIndex(int index) {
  //   _tabIndex = index;
  //   notifyListeners();
  // }
}