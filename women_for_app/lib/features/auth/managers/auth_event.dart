// lib/features/auth/managers/auth_event.dart

abstract class AuthEvent {}

// Login eventlari
class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested({
    required this.username,
    required this.password,
  });
}

// Registratsiya eventlari
class SendVerificationCodeRequested extends AuthEvent {
  final String phoneNumber;

  SendVerificationCodeRequested(this.phoneNumber);
}

class VerifyCodeRequested extends AuthEvent {
  final String phoneNumber;
  final String code;

  VerifyCodeRequested({
    required this.phoneNumber,
    required this.code,
  });
}

class RegisterCompleted extends AuthEvent {
  final String username;
  final String phoneNumber;
  final String password;
  final String? code;
  final String? firstName;
  final String? lastName;

  RegisterCompleted({
    required this.username,
    required this.phoneNumber,
    required this.password,
    this.code,
    this.firstName,
    this.lastName,
  });
}

class RefreshTokenRequested extends AuthEvent {}

class GetProfileRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

class CheckUsernameRequested extends AuthEvent {
  final String username;

  CheckUsernameRequested(this.username);
}

class CheckAuthStatus extends AuthEvent {}