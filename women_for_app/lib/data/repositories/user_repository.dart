import 'package:women_for_app/core/client.dart';

import '../../core/result.dart';
import '../model/user/user_model.dart';

class UserRepository {
  final ApiClient _client;

  UserRepository({required ApiClient client}) : _client = client;

  Future<Result<UserModel>> getUser() async {
    final result = await _client.get<Map<String, dynamic>>('/users/GetProfile');
    return result.fold(
      (error) => Result.error(error),
      (value) => Result.ok(UserModel.fromJson(value)),
    );
  }
}
