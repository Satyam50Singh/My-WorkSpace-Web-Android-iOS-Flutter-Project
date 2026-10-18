import 'package:flutter/material.dart';

class DrawerMenuItems {
  final String title;
  final IconData icon;
  final String route;
  final bool isDivider;
  final List<SubMenuItems> subItems;

  DrawerMenuItems({
    required this.title,
    required this.icon,
    required this.route,
    required this.isDivider,
    required this.subItems,
  });
}

class SubMenuItems {
  final String title;
  final IconData icon;
  final String route;
  final bool isDivider;
  bool isSelected = false;

  SubMenuItems(
    this.isSelected, {
    required this.title,
    required this.icon,
    required this.route,
    required this.isDivider,
  });
}
