import 'package:flutter/material.dart';

class ReuseableSmallCard extends StatelessWidget {
  const ReuseableSmallCard({this.cardChild, this.colour});

  final Widget? cardChild;
  final Color? colour;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        // minHeight: MediaQuery.of(context).size.width / 1.5,
        maxWidth: MediaQuery.of(context).size.width / 3.3,
        minWidth: MediaQuery.of(context).size.width / 3.3,
      ),
      margin: const EdgeInsets.all(10.0),
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
