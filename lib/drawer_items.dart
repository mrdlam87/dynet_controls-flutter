import 'package:flutter/material.dart';
import './models/drawer_item.dart';

class DrawerItems {
  static const home = DrawerItem(title: 'Home', icon: Icons.home);
  static const search = DrawerItem(title: 'Search', icon: Icons.search);
  static const projects = DrawerItem(title: 'Projects', icon: Icons.file_copy);
  static const profile = DrawerItem(title: 'Profile', icon: Icons.person);
  static const settings = DrawerItem(title: 'Settings', icon: Icons.settings);
  static const exit = DrawerItem(title: 'Exit', icon: Icons.logout);

  static final List<DrawerItem> all = [
    home,
    search,
    projects,
    profile,
    settings,
    exit,
  ];
}
