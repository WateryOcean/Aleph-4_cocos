import 'package:flutter/material.dart';
import '../data/event_repository.dart';
import '../models/event_model.dart';
 
class EventProvider extends ChangeNotifier {
  final EventRepository _eventRepository = EventRepository.instance;
 
  List<EventModel> _events = [];
  bool _isLoading = false;
  String _errorMessage = '';
 
  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
 
  // Mengambil daftar event masa mendatang (Upcoming)
  List<EventModel> get upcomingEvents =>
      _events.where((e) => e.isUpcoming).toList();
 
  // Mengambil daftar event yang sudah selesai (Completed)
  List<EventModel> get completedEvents =>
      _events.where((e) => !e.isUpcoming).toList();
 
  /// Fungsi utama untuk memuat data event dari npoint API
  Future<void> loadEvents() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
 
    try {
      _events = await _eventRepository.fetchEvents();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}