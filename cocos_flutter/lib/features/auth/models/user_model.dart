class UserModel {
  final String id;
  final String fullName;
  final String username;
  final String dob;
  final String email;
  final String phoneNumber;
  final String country;
  final String gender;
  final String profilePicture;
 
  UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.dob,
    required this.email,
    required this.phoneNumber,
    required this.country,
    required this.gender,
    required this.profilePicture,
  });
 
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      username: json['username'] ?? '',
      dob: json['dob'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      country: json['country'] ?? '',
      gender: json['gender'] ?? 'Male',
      profilePicture: json['profilePicture'] ?? 'assets/logo_images/itachi_profile.png',
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'dob': dob,
      'email': email,
      'phoneNumber': phoneNumber,
      'country': country,
      'gender': gender,
      'profilePicture': profilePicture,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? username,
    String? dob,
    String? email,
    String? phoneNumber,
    String? country,
    String? gender,
    String? profilePicture,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      dob: dob ?? this.dob,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      country: country ?? this.country,
      gender: gender ?? this.gender,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}