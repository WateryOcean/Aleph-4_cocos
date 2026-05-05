import '../models/user_model.dart';

class AuthDummyData {
  static final Map<String, String> dummyUsers = {
    'cosplayer@example.com': 'password123',
    'admin@cocos.com': 'admin2026',
    'guest@cocos.com': 'guestpass',
  };

  static final Map<String, UserModel> userProfiles = {
    'cosplayer@example.com': UserModel(
      id: 'u_002',
      fullName: 'Luna Starweave',
      username: '@luna_cosplay',
      dob: '15/03/1998',
      email: 'cosplayer@example.com',
      phoneNumber: '+1 555 100 2000',
      country: 'United States',
      gender: 'Female',
      profilePicture: 'assets/logo_images/water_profile.jpg',
    ),
    'admin@cocos.com': UserModel(
      id: 'u_001',
      fullName: 'Aleph-4',
      username: '@aleph_cos4er',
      dob: '01/07/2005',
      email: 'admin@cocos.com',
      phoneNumber: '+1 234 567 890',
      country: 'United States',
      gender: 'Male',
      profilePicture: 'assets/logo_images/itachi_profile.png',
    ),
    'guest@cocos.com': UserModel(
      id: 'u_003',
      fullName: 'Guest User',
      username: '@guest_cocos',
      dob: '',
      email: 'guest@cocos.com',
      phoneNumber: '',
      country: '',
      gender: 'Male',
      profilePicture: 'assets/logo_images/itachi_profile.png',
    ),
  };
}
