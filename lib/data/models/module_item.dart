import 'package:flutter/material.dart';

import 'home_category.dart';

class ModuleItem {
  const ModuleItem({
    required this.id,
    required this.titleEs,
    required this.titleQu,
    required this.icon,
    required this.route,
    required this.color,
    required this.homeCategory,
    this.thumbnailAsset,
    this.thumbnailUrl,
    this.subtitleEs,
    this.subtitleQu,
  });

  final String id;
  final String titleEs;
  final String titleQu;
  final IconData icon;
  final String route;
  final Color color;
  final HomeCategory homeCategory;
  final String? thumbnailAsset;
  final String? thumbnailUrl;
  final String? subtitleEs;
  final String? subtitleQu;

  String title(bool isKichwa) => isKichwa ? titleQu : titleEs;
  String? subtitle(bool isKichwa) =>
      isKichwa ? (subtitleQu ?? subtitleEs) : subtitleEs;
}
