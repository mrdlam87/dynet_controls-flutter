import 'package:dynet_controls_v2/models/channel.dart';
import 'package:dynet_controls_v2/providers/area_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/area.dart';

class ChannelSlider extends StatelessWidget {
  ChannelSlider({
    required this.area,
    required this.channel,
    required this.address,
    required this.currentLevel,
    // required this.onChange,
  });

  final Area area;
  final Channel channel;
  final String address;
  // final Function(double) onChange;
  final double currentLevel;

  @override
  Widget build(BuildContext context) {
    Future _sendChannelLevel(double level) async {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      try {
        await Provider.of<AreaData>(context, listen: false)
            .sendCurrentChannelLevel(area, channel, level);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString(),
            ),
            elevation: 10,
            margin: const EdgeInsets.all(10),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black87,
            action: SnackBarAction(
                label: 'DISMISS',
                textColor: kActiveButtonColour,
                onPressed: () {
                  // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                }),
          ),
        );
      }
    }

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 1,
        // showValueIndicator: ShowValueIndicator.always,
        thumbShape: const RoundSliderThumbShape(
            elevation: 10, pressedElevation: 10, enabledThumbRadius: 8),
        thumbColor: kItemColour,
        activeTrackColor: kActiveButtonColour,
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
      ),
      child: Slider(
        inactiveColor: kInactiveColour,
        value: currentLevel,
        max: 100,
        label: '${currentLevel.round().toString()}%',
        onChanged: (value) {
          // onChange(value);
          Provider.of<AreaData>(context, listen: false)
              .setCurrentChannelLevel(area, channel, value);
        },
        onChangeEnd: (value) {
          _sendChannelLevel(value);
        },
      ),
    );
  }
}
