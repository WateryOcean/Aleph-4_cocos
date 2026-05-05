import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  UserService._();
  static final UserService instance = UserService._();

  String fullName = '';
  String username = '';
  String email = '';
  String phone = '';
  String gender = 'Male';
  String profilePicture = 'assets/logo_images/itachi_profile.png';

  bool _loaded = false;

  bool get isPopulated => fullName.isNotEmpty;

  void setUser({
    required String fullName,
    required String username,
    required String email,
    required String phone,
    required String gender,
    String profilePicture = 'assets/logo_images/itachi_profile.png',
  }) {
    this.fullName = fullName;
    this.username = username;
    this.email = email;
    this.phone = phone;
    this.gender = gender;
    this.profilePicture = profilePicture;
    _loaded = true;
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', fullName);
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('gender', gender);
    await prefs.setString('profilePicture', profilePicture);
  }

  Future<void> loadFromPrefs() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    fullName = prefs.getString('fullName') ?? '';
    username = prefs.getString('username') ?? '';
    email = prefs.getString('email') ?? '';
    phone = prefs.getString('phone') ?? '';
    gender = prefs.getString('gender') ?? 'Male';
    profilePicture = prefs.getString('profilePicture') ??
        'assets/logo_images/itachi_profile.png';
    if (fullName.isNotEmpty) _loaded = true;
  }

  Future<void> signOut() async {
    fullName = '';
    username = '';
    email = '';
    phone = '';
    gender = 'Male';
    profilePicture = 'assets/logo_images/itachi_profile.png';
    _loaded = false;
    final prefs = await SharedPreferences.getInstance();
    for (final key in ['fullName', 'username', 'email', 'phone', 'gender', 'profilePicture']) {
      await prefs.remove(key);
    }
  }
}
