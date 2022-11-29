import 'package:flutter/material.dart';
import '../constants.dart';
import '../Components/preset_card.dart';
import '../Components/small_preset_card.dart';
import '../models/area.dart';
import '../providers/area_data.dart';
import 'package:provider/provider.dart';
import 'package:declarative_refresh_indicator/declarative_refresh_indicator.dart';

class PresetPage extends StatefulWidget {
  PresetPage({required this.areaList, this.gridView = true, this.gridSize = 2});

  final List<Area> areaList;
  final bool gridView;
  final int gridSize;

  @override
  _PresetPageState createState() => _PresetPageState();
}

class _PresetPageState extends State<PresetPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  bool _refreshing = false;

  Future updateDynet() async {
    final areaData = Provider.of<AreaData>(context, listen: false);

    setState(() => _refreshing = true);
    for (Area area in widget.areaList) {
      await areaData.requestCurrentPreset(area);
      await areaData.requestCurrentChannelLevel(area, area.areaChannels[0]);
    }
    setState(() => _refreshing = false);
  }

  List<Widget> buildPresetCards() {
    List<Widget> presetCards = [];

    for (Area area in widget.areaList) {
      presetCards.add(
        PresetCard(
          area: area,
        ),
      );
    }
    presetCards.add(const SizedBox(height: 50.0, width: double.infinity));

    return presetCards;
  }

  List<Widget> buildSmallPresetCards() {
    List<Widget> presetCards = [];
    for (Area area in widget.areaList) {
      presetCards.add(SmallPresetCard(area: area));
    }
    presetCards.add(const SizedBox(height: 10.0, width: double.infinity));

    return presetCards;
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: kFadeDuration);

    _animationController!.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    _refreshing = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final expandedViewBuilder = isLandscape
        ? ListView(
            children: <Widget>[
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: <Widget>[...buildPresetCards()],
              )
            ],
          )
        : ListView.builder(
            itemCount: buildPresetCards().length,
            itemBuilder: (context, index) {
              return buildPresetCards()[index];
            },
          );

    final gridViewBuilder = GridView.builder(
      itemCount: buildSmallPresetCards().length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.gridSize,
        mainAxisExtent: 125,
      ),
      itemBuilder: (context, index) {
        return buildSmallPresetCards()[index];
      },
    );

    return FadeTransition(
      opacity: _animationController!,
      child: DeclarativeRefreshIndicator(
        refreshing: _refreshing,
        color: kItemColour,
        backgroundColor: kBackgroundColour,
        onRefresh: () async {
          await updateDynet();
        },
        child: widget.gridView ? gridViewBuilder : expandedViewBuilder,
      ),
    );
  }
}
