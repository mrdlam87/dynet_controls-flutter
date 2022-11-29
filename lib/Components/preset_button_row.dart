import 'package:flutter/material.dart';
import '../Components/preset_button.dart';
import '../models/area.dart';

class PresetButtonRow extends StatelessWidget {
  const PresetButtonRow({
    required this.area,
    required this.address,
  });
  final Area area;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runAlignment: WrapAlignment.center,
      children: area.areaPresets
          .map((preset) => PresetButton(
                area: area,
                preset: preset.presetNumber,
                address: address,
                label: preset.presetName,
                buttonState: area.areaCurrentPreset == preset.presetNumber
                    ? true
                    : false,
              ))
          .toList(),
    );
  }
}
