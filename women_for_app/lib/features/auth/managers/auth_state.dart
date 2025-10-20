
import 'package:women_for_app/data/model/auth/auth_model.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final bool hasError;
  final String? errorMessage;
  final UserData? userData;
  final bool verificationCodeSent;
  final bool verificationCodeVerified;
  final bool usernameAvailable;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.hasError = false,
    this.errorMessage,
    this.userData,
    this.verificationCodeSent = false,
    this.verificationCodeVerified = false,
    this.usernameAvailable = false,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? hasError,
    String? errorMessage,
    UserData? userData,
    bool? verificationCodeSent,
    bool? verificationCodeVerified,
    bool? usernameAvailable,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      userData: userData ?? this.userData,
      verificationCodeSent: verificationCodeSent ?? this.verificationCodeSent,
      verificationCodeVerified: verificationCodeVerified ?? this.verificationCodeVerified,
      usernameAvailable: usernameAvailable ?? this.usernameAvailable,
    );
  }
}