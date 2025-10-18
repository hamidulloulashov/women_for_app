import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_for_app/features/home/managers/userBloc/user_state.dart';
import '../../../../core/utils/status.dart';
import '../../../../data/repositories/user_repository.dart';
part 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserState.initial()) {
    on<FetchUser>((event, emit) async {
      emit(state.copyWith(status: Status.loading));

      final result = await userRepository.getUser();

      result.fold(
            (error) {
          emit(state.copyWith(
            status: Status.error,
            errorMessage: error.toString(),
          ));
        },
            (user) {
          emit(state.copyWith(
            status: Status.success,
            user: user,
          ));
        },
      );
    });
  }
}