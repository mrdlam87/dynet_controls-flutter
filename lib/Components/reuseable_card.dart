import 'package:flutter/material.dart';

class ReuseableCard extends StatelessWidget {
  const ReuseableCard({this.cardChild, this.colour});

  final Widget? cardChild;
  final Color? colour;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      constraints: BoxConstraints(
          // minHeight: MediaQuery.of(context).orientation ==  Orientation.portrait ? MediaQuery.of(context).size.width / 1.5 : 0,
          maxWidth: screenWidth),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colour,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
      ),
      child: cardChild,
    );
  }
}
