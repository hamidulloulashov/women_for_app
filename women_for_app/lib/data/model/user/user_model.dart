class UserModel {
  final int id;
  final String fullName;
  final String username;
  final String bio;
  final String phone;
  final String email;
  final String avatar;

  UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.bio,
    required this.phone,
    required this.email,
    required this.avatar,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'],
      username: json['username'],
      bio: json['bio'],
      phone: json['phone'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }
}
