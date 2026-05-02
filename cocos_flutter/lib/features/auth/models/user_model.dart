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

  // Factory untuk membuat UserModel dari JSON map dikedepannya (untuk UAS nanti)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      username: json['username'],
      dob: json['dob'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      country: json['country'],
      gender: json['gender'],
      profilePicture: json['profilePicture'],
    );
  }

  // Metode convert UserModel ke JSON map (untuk UAS nanti)
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
}
