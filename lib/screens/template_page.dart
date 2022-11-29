import '../constants.dart';
import 'package:flutter/material.dart';

class TemplatePage extends StatelessWidget {
  const TemplatePage({required this.isDrawerOpen, required this.openDrawer, this.title = ''});

  final String title;
  final bool isDrawerOpen;
  final VoidCallback openDrawer;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: kBackgroundColour,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(
                isDrawerOpen ? Icons.close : Icons.menu,
                color: kItemColour,
              ),
              onPressed: openDrawer,
            ),
            title: Text(title, style: kCategoryStyle),
          )
        ],
      ),
    );
  }
}
