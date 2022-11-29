import 'package:dynet_controls_v2/providers/area_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/area.dart';
import '../models/preset.dart';

class PresetDropdownButton extends StatelessWidget {
  const PresetDropdownButton({
    required this.area,
    required this.value,
    // required this.onChange,
  });

  final Area area;
  final String value;
  // final Function(String?) onChange;

  DropdownMenuItem<String> buildMenuItem(Preset preset) => DropdownMenuItem(
        value: preset.presetName,
        child: Material(
          color: Colors.black.withOpacity(0),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          elevation: 10.0,
          child: Container(
            height: 32,
            width: 72,
            decoration: BoxDecoration(
                border: Border.all(
                  color: kActiveButtonColour,
                ),
                color: area.areaCurrentPreset == preset.presetNumber
                    ? kActiveButtonColour
                    : Colors.black.withOpacity(0),
                borderRadius: BorderRadius.circular(5.0)),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                preset.presetName,
                style: kPresetButtonStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    Future _sendPreset(String preset) async {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      try {
        await Provider.of<AreaData>(context, listen: false)
            .sendCurrentPresetName(area, preset);
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

    List<Preset> items = area.areaPresets;
    return DropdownButton<String>(
      iconSize: 0,
      underline: Container(
        color: Colors.transparent,
      ),
      borderRadius: BorderRadius.circular(5.0),
      value: value,
      dropdownColor: kBackgroundColour,
      items: items.map(buildMenuItem).toList(),
      onChanged: (value) {
        _sendPreset(value!);
      },
    );
  }
}
