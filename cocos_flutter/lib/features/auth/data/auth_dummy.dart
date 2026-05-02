import '../models/user_model.dart';

class AuthDummyData {
  // Sample user untuk simulasi
  static UserModel currentUser = UserModel(
    id: 'u_001',
    fullName: 'Aleph-4',
    username: '@aleph_cos4er',
    dob: '01/07/2005',
    email: 'aleph@example.com',
    phoneNumber: '+1 234 567 890',
    country: 'United States',
    gender: 'Male',
    profilePicture: 'assets/logo_images/itachi_profile.png',
  );

  // Dummy credentials untuk login
  static final Map<String, String> dummyUsers = {
    'cosplayer@example.com': 'password123',
    'admin@cocos.com': 'admin2026',
    'guest@cocos.com': 'guestpass',
  };
}
