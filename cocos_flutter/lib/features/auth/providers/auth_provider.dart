import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/storage/pref_service.dart';
import '../models/user_model.dart';
import '../data/user_service.dart';

class AuthProvider extends ChangeNotifier {

  static const int SESSION_DURATION_DAYS = 30;
  static const String _sessionTimestampKey = 'session_timestamp';
  
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  UserModel? _user;
  bool _isLoading = false;
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Memeriksa apakah sesi yang tersimpan masih valid (belum kedaluwarsa)
  bool _isSessionValid() {
    final prefs = PrefService.instance.prefs;
    final int? sessionTimestamp = prefs.getInt(_sessionTimestampKey);
    
    if (sessionTimestamp == null) return false;
    
    final DateTime sessionStart = DateTime.fromMillisecondsSinceEpoch(sessionTimestamp);
    final DateTime expiryDate = sessionStart.add(Duration(days: SESSION_DURATION_DAYS));
    final DateTime now = DateTime.now();
    
    return now.isBefore(expiryDate);
  }

  /// Menyimpan timestamp saat ini sebagai waktu mulai sesi
  Future<void> _saveSessionTimestamp() async {
    final prefs = PrefService.instance.prefs;
    await prefs.setInt(_sessionTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Menghapus timestamp sesi (saat logout atau kedaluwarsa)
  Future<void> _clearSessionTimestamp() async {
    final prefs = PrefService.instance.prefs;
    await prefs.remove(_sessionTimestampKey);
  }

  /// 1. Cek Sesi Penyimpanan Saat Startup Aplikasi

  Future<void> initializeAuth() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    
    // Jika tidak ada user Firebase, hapus sesi dan tandai sebagai sudah diinisialisasi
    if (firebaseUser == null) {
      await _clearSessionTimestamp();
      _isInitialized = true;
      notifyListeners();
      return;
    }

    // Periksa apakah sesi masih valid
    if (!_isSessionValid()) {
      // Sesi kedaluwarsa - logout secara diam-diam
      debugPrint('Session expired after $SESSION_DURATION_DAYS days. Logging out.');
      await _clearSessionTimestamp();
      await FirebaseAuth.instance.signOut();
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {}
      await UserService.instance.signOut();
      _user = null;
      _isInitialized = true;
      notifyListeners();
      return;
    }

    final prefs = PrefService.instance.prefs;
    final String? userJson = prefs.getString('user_session');

    if (userJson != null) {
      _user = UserModel.fromJson(jsonDecode(userJson));
      _syncToLegacyUserService(_user!);
      _isInitialized = true;
      notifyListeners();
      return;
    }

    await _loadProfileFromFirestore(firebaseUser);
    _isInitialized = true;
    notifyListeners();
  }

  /// 2. Fungsi Login Email & Password via Firebase Authentication

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) return false;

      await _loadProfileFromFirestore(firebaseUser);
      await _saveSessionTimestamp();
      _isInitialized = true;
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('Gagal Sign In: ${e.code}');
      return false;
    } catch (e) {
      debugPrint('Gagal Sign In: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 3. Fungsi Daftar Akun Baru via Firebase Authentication

  Future<bool> signUp({
    required String fullName,
    required String username,
    required String dob,
    required String email,
    required String password,
    required String phoneNumber,
    required String country,
    required String gender,
    String profilePicture = 'assets/logo_images/itachi_profile.png',
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) return false;

      await firebaseUser.updateDisplayName(fullName);

      _user = UserModel(
        id: firebaseUser.uid,
        fullName: fullName,
        username: username,
        dob: dob,
        email: email,
        phoneNumber: phoneNumber,
        country: country,
        gender: gender,
        profilePicture: profilePicture,
      );

      await _firestore.collection('users').doc(firebaseUser.uid).set(_user!.toJson());

      final prefs = PrefService.instance.prefs;
      await prefs.setString('user_session', jsonEncode(_user!.toJson()));
      await _saveSessionTimestamp();
      _syncToLegacyUserService(_user!);
      _isInitialized = true;
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('Gagal Sign Up: ${e.code}');
      return false;
    } catch (e) {
      debugPrint('Gagal Sign Up: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 4. Fungsi Login Google Sign-In & Firebase Auth

  Future<bool> signInWithGoogle() async {

    try {
      _isLoading = true;
      notifyListeners();

      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        await _loadProfileFromFirestore(firebaseUser, googleFallbackEmail: googleUser.email);
        await _saveSessionTimestamp();
        _isInitialized = true;
        return true;
      }

      return false;

    } catch (e) {
      debugPrint('Gagal Google Sign In: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 5. Fungsi Logout Sesi Pengguna

  Future<void> logout() async {

    _user = null;
    final prefs = PrefService.instance.prefs;
    await prefs.remove('user_session');
    await _clearSessionTimestamp();

    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
    await FirebaseAuth.instance.signOut();
    await UserService.instance.signOut();
    _isInitialized = true;
    notifyListeners();
  }

  /// Mengambil profil pengguna dari Firestore

  Future<void> _loadProfileFromFirestore(User firebaseUser, {String? googleFallbackEmail}) async {
    try {
      final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();

      if (doc.exists && doc.data() != null) {
        _user = UserModel.fromJson(doc.data()!);
      } else {
        _user = UserModel(
          id: firebaseUser.uid,
          fullName: firebaseUser.displayName ?? 'Cosplayer',
          username: (googleFallbackEmail ?? firebaseUser.email ?? 'user').split('@')[0],
          dob: '-',
          email: firebaseUser.email ?? googleFallbackEmail ?? '',
          phoneNumber: firebaseUser.phoneNumber ?? '-',
          country: 'Indonesia',
          gender: 'Male',
          profilePicture: firebaseUser.photoURL ?? 'assets/logo_images/itachi_profile.png',
        );
        await _firestore.collection('users').doc(firebaseUser.uid).set(_user!.toJson());
      }

      final prefs = PrefService.instance.prefs;
      await prefs.setString('user_session', jsonEncode(_user!.toJson()));
      _syncToLegacyUserService(_user!);
    } catch (e) {
      debugPrint('Gagal memuat profil dari Firestore: $e');
    }
  }

  /// Sinkronisasi otomatis ke UserService lama

  void _syncToLegacyUserService(UserModel u) {
    UserService.instance.setUser(
      fullName: u.fullName,
      username: u.username,
      email: u.email,
      phone: u.phoneNumber,
      gender: u.gender,
      profilePicture: u.profilePicture,
    );
  }

  /// Memperbarui profil user di Firestore, SharedPreferences, dan state lokal
  Future<void> updateUserProfile(UserModel updatedUser) async {
    if (_user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(_user!.id)
          .set(updatedUser.toJson());

      final prefs = PrefService.instance.prefs;
      await prefs.setString('user_session', jsonEncode(updatedUser.toJson()));

      _user = updatedUser;
      _syncToLegacyUserService(updatedUser);

      notifyListeners();
    } catch (e) {
      debugPrint('Failed to update user profile: $e');
      rethrow;
    }
  }
}