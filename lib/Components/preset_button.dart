import 'package:dynet_controls_v2/providers/area_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/area.dart';

class PresetButton extends StatelessWidget {
  const PresetButton({
    required this.area,
    required this.preset,
    required this.address,
    required this.label,
    this.buttonState = false,
  });

  final Area area;
  final int preset;
  final String address;
  final String label;
  final bool? buttonState;

  @override
  Widget build(BuildContext context) {
    Future _sendPreset() async {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      try {
        await Provider.of<AreaData>(context, listen: false)
            .sendCurrentPreset(area, preset);
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

    return RawMaterialButton(
      child: Text(
        label,
        style: kPresetButtonStyle,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: const BorderSide(
            color: kActiveButtonColour,
          )),
      fillColor:
          buttonState! ? kActiveButtonColour : Colors.black.withOpacity(0),
      elevation: 10.0,
      constraints: const BoxConstraints.tightFor(
        width: 72.0,
        height: 32.0,
      ),
      onPressed: _sendPreset,
    );
  }
}
