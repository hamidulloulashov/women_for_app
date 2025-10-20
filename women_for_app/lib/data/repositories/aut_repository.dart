import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_for_app/core/client.dart';
import 'package:women_for_app/core/result.dart';
import 'package:women_for_app/data/model/auth/auth_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _sessionKey = 'session_id';
  static const String _codeKey = 'verification_code';
  static const String _phoneKey = 'phone_number';

  // Check Username
  Future<Result<CheckUsernameResponse>> checkUsername(String username) async {
    try {
      final result = await _apiClient.post<Map<String, dynamic>>(
        '/users/CheckUsername',
        data: {'username': username},
      );

      return result.fold(
        (error) => Result.error(error),
        (data) {
          final response = CheckUsernameResponse.fromJson(data);
          return Result.ok(response);
        },
      );
    } catch (e) {
      return Result.error(Exception('Username tekshirishda xatolik: $e'));
    }
  }

  // Send Verification Code
  Future<Result<Map<String, dynamic>>> sendVerificationCode(
    String phoneNumber,
  ) async {
    try {
      final formattedPhone = phoneNumber.startsWith('+')
          ? phoneNumber
          : '+$phoneNumber';

      final result = await _apiClient.post<Map<String, dynamic>>(
        '/users/SendAuthVerificationCode',
        data: {'phone': formattedPhone},
      );

      return result.fold(
        (error) => Result.error(error),
        (data) async {
          final prefs = await SharedPreferences.getInstance();
          final sessionId = data['session'] ?? data['session_id'];
          if (sessionId != null) {
            await prefs.setString(_sessionKey, sessionId.toString());
          }
          await prefs.setString(_phoneKey, formattedPhone);
          
          // Test kodi saqlab qolish (123456 backend'dan kelsa)
          await prefs.setString(_codeKey, '123456');
          
          return Result.ok(data);
        },
      );
    } catch (e) {
      return Result.error(Exception('SMS yuborishda xatolik: $e'));
    }
  }



  // Login
  Future<Result<AuthResponse>> login(LoginRequest request) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final session = prefs.getString(_sessionKey);
      final code = prefs.getString(_codeKey);
      final phone = prefs.getString(_phoneKey);

      if (session == null || code == null || phone == null) {
        return Result.error(
          Exception('Avval telefon raqamini verify qiling'),
        );
      }

      final loginData = {
        'username': request.username,
        'password': request.password,
        'phone': phone,
        'code': code,
        'session': session,
      };

      final result = await _apiClient.post<Map<String, dynamic>>(
        '/users/Login',
        data: loginData,
      );

      return result.fold(
        (error) => Result.error(error),
        (data) async {
          final authResponse = AuthResponse.fromJson(data);
          await _saveTokens(authResponse.access, authResponse.refresh);
          if (authResponse.user != null) {
            await _saveUserData(authResponse.user!);
          }
          await _clearVerificationData(prefs);
          return Result.ok(authResponse);
        },
      );
    } catch (e) {
      return Result.error(Exception('Login xatolik: $e'));
    }
  }

  // Token Obtain Pair
  Future<Result<AuthResponse>> obtainToken(LoginRequest request) async {
    try {
      final result = await _apiClient.post<Map<String, dynamic>>(
        '/users/TokenObtainPair',
        data: request.toJson(),
      );

      return result.fold(
        (error) => Result.error(error),
        (data) async {
          final authResponse = AuthResponse.fromJson(data);
          await _saveTokens(authResponse.access, authResponse.refresh);
          if (authResponse.user != null) {
            await _saveUserData(authResponse.user!);
          }
          return Result.ok(authResponse);
        },
      );
    } catch (e) {
      return Result.error(Exception('Token olishda xatolik: $e'));
    }
  }

  // Refresh Token
  Future<Result<AuthResponse>> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshTokenStr = prefs.getString(_refreshTokenKey);

      if (refreshTokenStr == null) {
        return Result.error(Exception('Refresh token topilmadi'));
      }

      final result = await _apiClient.post<Map<String, dynamic>>(
        '/users/TokenRefresh',
        data: {'refresh': refreshTokenStr},
      );

      return result.fold(
        (error) => Result.error(error),
        (data) async {
          final authResponse = AuthResponse.fromJson(data);
          await _saveTokens(authResponse.access, authResponse.refresh);
          return Result.ok(authResponse);
        },
      );
    } catch (e) {
      return Result.error(Exception('Token yangilashda xatolik: $e'));
    }
  }

  // Get Profile
  Future<Result<UserData>> getProfile() async {
    try {
      final result = await _apiClient.get<Map<String, dynamic>>(
        '/users/GetProfile',
      );

      return result.fold(
        (error) => Result.error(error),
        (data) async {
          final userData = UserData.fromJson(data);
          await _saveUserData(userData);
          return Result.ok(userData);
        },
      );
    } catch (e) {
      return Result.error(Exception('Profile olishda xatolik: $e'));
    }
  }

  // Update Profile
  Future<Result<UserData>> updateProfile(Map<String, dynamic> data) async {
    try {
      final result = await _apiClient.put<Map<String, dynamic>>(
        '/users/UpdateProfile',
        data: data,
      );

      return result.fold(
        (error) => Result.error(error),
        (responseData) async {
          final userData = UserData.fromJson(responseData);
          await _saveUserData(userData);
          return Result.ok(userData);
        },
      );
    } catch (e) {
      return Result.error(Exception('Profile yangilashda xatolik: $e'));
    }
  }

  // Change Phone
  Future<Result<Map<String, dynamic>>> changePhone(String newPhone) async {
    try {
      final formattedPhone = newPhone.startsWith('+') ? newPhone : '+$newPhone';

      final result = await _apiClient.post<Map<String, dynamic>>(
        '/users/SendCodeForChangePhone',
        data: {'phone': formattedPhone},
      );

      return result.fold(
        (error) => Result.error(error),
        (data) async {
          final prefs = await SharedPreferences.getInstance();
          final sessionId = data['session'] ?? data['session_id'];
          if (sessionId != null) {
            await prefs.setString('${_sessionKey}_phone_change', sessionId.toString());
          }
          await prefs.setString('${_phoneKey}_new', formattedPhone);
          return Result.ok(data);
        },
      );
    } catch (e) {
      return Result.error(Exception('Telefon o\'zgartirish kodi yuborishda xatolik: $e'));
    }
  }

  // Delete Profile
  Future<Result<void>> deleteProfile() async {
    try {
      final result = await _apiClient.delete<Map<String, dynamic>>(
        '/users/DeleteProfile',
      );

      return result.fold(
        (error) => Result.error(error),
        (_) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove(_accessTokenKey);
          await prefs.remove(_refreshTokenKey);
          await prefs.remove(_userDataKey);
          await _clearVerificationData(prefs);
          return Result.ok(null);
        },
      );
    } catch (e) {
      return Result.error(Exception('Profil o\'chirishda xatolik: $e'));
    }
  }

  // Logout
  Future<Result<void>> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.remove(_userDataKey);
      await _clearVerificationData(prefs);
      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception('Logout xatolik: $e'));
    }
  }

  // Helper Methods
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<void> _saveUserData(UserData userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(userData.toJson()));
  }

  Future<void> _clearVerificationData(SharedPreferences prefs) async {
    await prefs.remove(_sessionKey);
    await prefs.remove(_codeKey);
    await prefs.remove(_phoneKey);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<UserData?> getSavedUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userDataKey);
      if (userData != null) {
        return UserData.fromJson(jsonDecode(userData));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}