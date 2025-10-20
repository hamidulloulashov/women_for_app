
class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}

class RegisterRequest {
  final String username;
  final String phoneNumber;
  final String password;
  final String? firstName;
  final String? lastName;
  final String? email;

  RegisterRequest({
    required this.username,
    required this.phoneNumber,
    required this.password,
    this.firstName,
    this.lastName,
    this.email,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'phone_number': phoneNumber,
        'password': password,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (email != null) 'email': email,
      };
}

class VerificationRequest {
  final String phoneNumber;

  VerificationRequest({required this.phoneNumber});

  Map<String, dynamic> toJson() => {
        'phone_number': phoneNumber,
      };
}

class AuthResponse {
  final String access;
  final String refresh;
  final UserData? user;

  AuthResponse({
    required this.access,
    required this.refresh,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      access: json['access'] ?? '',
      refresh: json['refresh'] ?? '',
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
    );
  }
}

class UserData {
  final int id;
  final String username;
  final String? phoneNumber;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? avatar;

  UserData({
    required this.id,
    required this.username,
    this.phoneNumber,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      phoneNumber: json['phone_number'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'phone_number': phoneNumber,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'avatar': avatar,
      };
}

class CheckUsernameResponse {
  final bool available;
  final String? message;

  CheckUsernameResponse({
    required this.available,
    this.message,
  });

  factory CheckUsernameResponse.fromJson(Map<String, dynamic> json) {
    return CheckUsernameResponse(
      available: json['available'] ?? false,
      message: json['message'],
    );
  }
}