import 'package:flutter/material.dart';
import '../constants.dart';

class NarrowTextButton extends StatelessWidget {
  NarrowTextButton({required this.label, this.state = false, this.onPress});

  final String label;
  final bool state;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 17,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          label,
          style: TextStyle(
            color: state ? kActiveColour : kInactiveColour,
          ),
        ),
      ),
    );
  }
}