import '../Components/badge.dart';
import '../Components/preset_card.dart';
import 'package:flutter/material.dart';
import 'package:declarative_refresh_indicator/declarative_refresh_indicator.dart';
import '../constants.dart';
import '../Components/small_preset_card.dart';
import '../Components/small_preset_card_recent.dart';
import '../Components/small_preset_card_frequent.dart';
import '../models/area.dart';
import '../providers/area_data.dart';
import 'package:provider/provider.dart';

class OverviewPage extends StatefulWidget {
  OverviewPage(
      {required this.areaList, this.gridView = true, this.gridSize = 2});

  final List<Area> areaList;
  final bool gridView;
  final int gridSize;

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage>
    with TickerProviderStateMixin {
  AnimationController? _slideAnimationController;
  AnimationController? _fadeAnimationController;
  bool _refreshing = false;

  // Future updateDynet() async {
  //   var areaData = Provider.of<AreaData>(context, listen: false);
  //   setState(() => _refreshing = true);
  //   for (Area area in areaData.folders[0].areas) {
  //     await areaData.requestCurrentPreset(area);
  //   }
  //   setState(() => _refreshing = false);
  // }

  List<Widget> buildSmallPresetCards(List<Area> areaList) {
    List<Widget> presetCards = [];
    for (Area area in areaList) {
      presetCards.add(SmallPresetCard(area: area));
    }

    return presetCards;
  }

  List<Widget> buildSmallPresetCardsRecent(List<Area> areaList) {
    List<Widget> presetCards = [];
    for (Area area in areaList) {
      presetCards.add(SmallPresetCardRecent(area: area));
    }

    return presetCards;
  }

  List<Widget> buildSmallPresetCardsFrequent(List<Area> areaList) {
    List<Widget> presetCards = [];
    for (Area area in areaList) {
      presetCards.add(Badge(
        color: kActiveButtonColour,
        value: area.timesUsed.toString(),
        child: SmallPresetCardFrequent(area: area),
      ));
    }

    return presetCards;
  }

  @override
  void initState() {
    _slideAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _slideAnimationController!.forward();

    _fadeAnimationController = AnimationController(
        vsync: this, duration: kFadeDuration);

    _fadeAnimationController!.forward();

    // updateDynet();

    super.initState();
  }

  @override
  void dispose() {
    _slideAnimationController!.dispose();
    _fadeAnimationController!.dispose();
    _refreshing = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final areaData = Provider.of<AreaData>(context);

    final buildSummary = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (areaData.getRecentAreas.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 40),
              child: const Text(
                'Recently Used',
                style: kCategoryStyle,
                textAlign: TextAlign.center,
              ),
            ),
          if (areaData.getRecentAreas.isNotEmpty)
            Container(
              height: 125,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                    buildSmallPresetCardsRecent(areaData.getRecentAreas).length,
                itemBuilder: (context, index) {
                  return buildSmallPresetCardsRecent(
                      areaData.getRecentAreas)[index];
                },
              ),
            ),
          if (areaData.getFequentAreas.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 40),
              child: const Text(
                'Frequently Used',
                style: kCategoryStyle,
                textAlign: TextAlign.center,
              ),
            ),
          if (areaData.getFequentAreas.isNotEmpty)
            Container(
              height: 125,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                    buildSmallPresetCardsFrequent(areaData.getFequentAreas)
                        .length,
                itemBuilder: (context, index) {
                  return buildSmallPresetCardsFrequent(
                      areaData.getFequentAreas)[index];
                },
              ),
            ),
          areaData.getFavouriteAreas.isNotEmpty
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 40),
                  child: const Text(
                    'Favourites',
                    style: kCategoryStyle,
                    textAlign: TextAlign.center,
                  ),
                )
              : Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 40),
                  child: const Center(
                    child: Text(
                      'Add Favourites',
                      style: kCategoryStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
          ...areaData.getFavouriteAreas.map((area) => PresetCard(area: area)),
        ],
      ),
    );

    return DeclarativeRefreshIndicator(
      refreshing: _refreshing,
      color: kItemColour,
      backgroundColor: kBackgroundColour,
      onRefresh: () {
        // await updateDynet();
      },
      child: FadeTransition(
        opacity: _fadeAnimationController!,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-0.05, 0),
            end: Offset.zero,
          ).animate(_slideAnimationController!),
          child: buildSummary,
        ),
      ),
    );
  }
}
