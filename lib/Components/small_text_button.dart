import 'package:flutter/material.dart';
import '../constants.dart';

class SmallTextButton extends StatelessWidget {
  SmallTextButton({required this.label, this.onPress, this.state = false});

  final String label;
  final bool state;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 17,
      width: 40,
      child: TextButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.resolveWith(
                  (states) => EdgeInsets.zero),
              overlayColor: MaterialStateColor.resolveWith(
                  (states) => Colors.transparent)),
          onPressed: onPress,
          child: Text(
            label,
            style: TextStyle(
              color: state ? kActiveColour : kInactiveColour,
            ),
          )),
    );
  }
}