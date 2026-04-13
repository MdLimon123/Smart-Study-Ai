import 'package:flutter/material.dart';

/// Display model for library bottom sheets (rename, etc.).
class LibraryItem {
  final String id;
  final String title;
  final String subject;
  final Color subjectColor;
  final String date;
  final String size;
  final IconData? icon;
  final String? svgIcon;
  final Color iconColor;
  final String type;

  LibraryItem({
    required this.id,
    required this.title,
    required this.subject,
    required this.subjectColor,
    required this.date,
    required this.size,
    this.icon,
    this.svgIcon,
    required this.iconColor,
    required this.type,
  });
}
