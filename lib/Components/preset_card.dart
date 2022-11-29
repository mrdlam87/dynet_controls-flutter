import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:dynet_controls_v2/constants.dart';
import 'package:dynet_controls_v2/providers/area_data.dart';
import 'package:dynet_controls_v2/models/area.dart';
import 'reuseable_card.dart';
import 'preset_button_row.dart';
import 'channel_level_column.dart';
import 'channel_slider.dart';

class PresetCard extends StatefulWidget {
  PresetCard({required this.area});

  final Area area;

  @override
  State<PresetCard> createState() => _PresetCardState();
}

class _PresetCardState extends State<PresetCard> {
  bool showChannels = false;
  @override
  Widget build(BuildContext context) {
    final areaData = Provider.of<AreaData>(context);
    final address =
        Provider.of<AreaData>(context, listen: false).gatewayAddress;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final columnContents = AnimatedContainer(
        height: showChannels ? widget.area.areaChannels.length * 55 + 60 : 115,
        duration: const Duration(milliseconds: 200),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (!isLandscape) const SizedBox(height: 20),
              if (!isLandscape)
                Container(
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      FittedBox(
                        child: Switch(
                          value: showChannels,
                          activeColor: kItemColour,
                          onChanged: (value) {
                            setState(() {
                              showChannels = value;
                            });
                          },
                        ),
                      ),
                      const Text(
                        'Expand',
                        style: TextStyle(color: kInactiveColour),
                      )
                    ],
                  ),
                ),
              if (!showChannels)
                Text(
                  '${widget.area.areaChannels[0].channelName}: ${widget.area.areaChannels[0].currentChannelLevel.toInt()}%',
                  style: kChannelTextStyle,
                ),
              showChannels
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: ChannelLevelColumn(
                          area: widget.area, address: address),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: ChannelSlider(
                        area: widget.area,
                        channel: widget.area.areaChannels[0],
                        address: address,
                        currentLevel:
                            widget.area.areaChannels[0].currentChannelLevel,
                      ),
                    ),
            ],
          ),
        ));

    // Future updateDynetSingle(Area area) async {
      // if (!_refreshing) {
      //   setState(() => _refreshing = true);
      // }
      // await areaData.requestCurrentPreset(area);
      // await areaData.requestCurrentChannelLevel(area, area.areaChannels![0]);
      // if (_refreshing) {
      //   await Future.delayed(Duration(milliseconds: 100), () {
      //     setState(() => _refreshing = false);
      //   });
      // }
    // }

    return FocusDetector(
      onFocusGained: () async {
        // await updateDynetSingle(widget.area);
      },
      child: ReuseableCard(
        colour: kCardColour,
        cardChild: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Text(
                    widget.area.areaName,
                    style: kCardTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                  ListTile(
                    trailing: FavouritesButton(
                      isFavourite: areaData.isAreaFavourite(widget.area),
                      onPress: () {
                        if (!areaData.isAreaFavourite(widget.area)) {
                          areaData.addPresetCard(widget.area);
                        } else {
                          areaData.removePresetCard(widget.area);
                        }
                      },
                    ),
                    leading: Icon(
                      widget.area.areaIcon,
                      color: kItemColour,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: Center(
                          child: PresetButtonRow(
                    area: widget.area,
                    address: address,
                  ))),
                  if (isLandscape) Expanded(child: columnContents)
                ],
              ),
              if (!isLandscape) columnContents,
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class FavouritesButton extends StatelessWidget {
  FavouritesButton({this.isFavourite = false, this.onPress});

  bool? isFavourite;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 20,
      icon: Icon(
        Icons.star,
        color: isFavourite! ? kItemColour : kInactiveColour,
      ),
      onPressed: onPress,
    );
  }
}
