import '../constants.dart';
import 'package:flutter/material.dart';
import '../Components/channel_slider.dart';
import '../models/channel.dart';
import '../models/area.dart';

class ChannelLevelColumn extends StatelessWidget {
  ChannelLevelColumn({
    required this.area,
    required this.address,
    this.channelList,
  });

  final Area area;
  final String address;
  final List<Channel>? channelList;

  @override
  Widget build(BuildContext context) {
    var channels = channelList ?? area.areaChannels;

    return Column(
      children: channels
          .map((channel) => Column(
                children: <Widget>[
                  Text(
                    '${channel.channelName}: ${channel.currentChannelLevel.toInt()}%',
                    style: kChannelTextStyle,
                  ),
                  ChannelSlider(
                    area: area,
                    channel: channel,
                    address: address,
                    currentLevel: channel.currentChannelLevel,
                  ),
                  const SizedBox(height: 10)
                ],
              ))
          .toList(),
    );
  }
}
