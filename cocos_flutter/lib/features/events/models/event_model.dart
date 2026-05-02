import 'package:flutter/material.dart';

class EventModel {
  final String id;
  final String title;
  final String category;
  final String date;
  final String location;
  final String time;
  final String imageUrl; // Stores the asset path
  final String description;
  final String contactInfo;
  final Map<String, String> socialMedia;
  final bool isUpcoming;
  final Color accentColor;

  EventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.location,
    required this.time,
    required this.imageUrl,
    required this.description,
    required this.contactInfo,
    required this.socialMedia,
    this.isUpcoming = true,
    required this.accentColor,
  });
}
