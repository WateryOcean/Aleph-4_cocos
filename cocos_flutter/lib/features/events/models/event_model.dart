import 'package:flutter/material.dart';

class EventModel {
  final String id;
  final String title;
  final String category;
  final String date;
  final String location;
  final String time;
  final String imageUrl;
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

  factory EventModel.fromJson(Map<String, dynamic> json) {
  return EventModel(
    id: json['id'],
    title: json['title'],
    category: json['category'],
    date: json['date'],
    location: json['location'],
    time: json['time'],
    imageUrl: json['imageUrl'],
    description: json['description'],
    contactInfo: json['contactInfo'],
    socialMedia: Map<String, String>.from(json['socialMedia']),
    isUpcoming: json['isUpcoming'] ?? true,
    accentColor: Color(int.parse(json['accentColor'])),
  );
}
}

