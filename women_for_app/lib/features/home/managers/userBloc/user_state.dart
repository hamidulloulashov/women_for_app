import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/status.dart';
import '../../../../data/model/user/user_model.dart';

part 'user_state.freezed.dart';

@freezed
abstract class UserState with _$UserState {
  const factory UserState({
    required Status status,
    String? errorMessage,
    UserModel? user,
  }) = _UserState;

  factory UserState.initial() => const UserState(
    status: Status.initial,
    errorMessage: null,
    user: null,
  );
}
