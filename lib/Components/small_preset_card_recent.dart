import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynet_controls_v2/models/area.dart';
import 'package:dynet_controls_v2/providers/area_data.dart';
import 'package:dynet_controls_v2/constants.dart';
import 'reuseable_small_card.dart';
import 'preset_card.dart';
import 'preset_dropdown_button.dart';
import 'hero_dialog_route.dart';
import 'custom_rect_tween.dart';

class SmallPresetCardRecent extends StatelessWidget {
  const SmallPresetCardRecent({required this.area});

  final Area area;

  @override
  Widget build(BuildContext context) {
    var areaData = Provider.of<AreaData>(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) => Center(
              child: _SmallPresetPopupCard(area: area),
            ),
          ),
        );
      },
      child: Hero(
        tag: '${area.areaNumber}.r',
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        child: Material(
          color: Colors.transparent,
          child: ReuseableSmallCard(
            colour: kCardColour,
            cardChild: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(
                  area.areaIcon,
                  color: kItemColour,
                  size: 20,
                ),
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      area.areaName,
                      style: kCardSmallTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                PresetDropdownButton(
                  area: area,
                  value: area.areaCurrentPresetName,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SmallPresetPopupCard extends StatelessWidget {
  const _SmallPresetPopupCard({required this.area});
  final Area area;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '${area.areaNumber}.r',
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin!, end: end!);
      },
      child: Material(
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: PresetCard(
            area: area,
          ),
        ),
      ),
    );
  }
}
