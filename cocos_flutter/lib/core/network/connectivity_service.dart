import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'sync_service.dart'; 
 
class ConnectivityService {
  ConnectivityService._();
  static final ConnectivityService instance = ConnectivityService._();
 
  final StreamController<bool> _connectionController = StreamController<bool>.broadcast();
  bool _isConnected = true;
 
  bool get isConnected => _isConnected;
  Stream<bool> get connectionStream => _connectionController.stream;
 
  void init() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final bool previousStatus = _isConnected;
      _isConnected = results.isNotEmpty && results.first != ConnectivityResult.none;
      _connectionController.add(_isConnected);
 
      // Pemicu Sync Service saat koneksi internet kembali tersedia
      if (!previousStatus && _isConnected) {
        SyncService.triggerSync();
      }
    });
  }
 
  void dispose() {
    _connectionController.close();
  }
}