import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';
import '../models/event_model.dart';
 
class EventRepository {
  EventRepository._();
  static final EventRepository instance = EventRepository._();
 
  /// Mengambil data event dari npoint API
  Future<List<EventModel>> fetchEvents() async {
    try {
      final response = await ApiService.instance.getKatalogCocos();
      // Mengambil array map dengan key 'events' dari npoint JSON
      final List<dynamic> eventData = response.data['events'];
      return eventData.map((json) => EventModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('EventRepository Error: $e');
      throw Exception('Gagal memuat daftar event dari server.');
    }
  }
}