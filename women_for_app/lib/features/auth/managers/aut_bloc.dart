
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_for_app/data/model/auth/auth_model.dart';
import 'package:women_for_app/data/repositories/aut_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthState()) {
    on<LoginRequested>(_onLoginRequested);

    on<SendVerificationCodeRequested>(_onSendVerificationCodeRequested);

    on<RefreshTokenRequested>(_onRefreshTokenRequested);

    on<GetProfileRequested>(_onGetProfileRequested);

    on<LogoutRequested>(_onLogoutRequested);

    on<CheckUsernameRequested>(_onCheckUsernameRequested);

    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, hasError: false));

    final result = await _authRepository.login(
      LoginRequest(
        username: event.username,
        password: event.password,
      ),
    );

    result.fold(
      (error) {
        emit(state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: error.toString(),
        ));
      },
      (authResponse) {
        emit(state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userData: authResponse.user,
          hasError: false,
        ));
      },
    );
  }

  Future<void> _onSendVerificationCodeRequested(
    SendVerificationCodeRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, hasError: false));

    final result = await _authRepository.sendVerificationCode(event.phoneNumber);

    result.fold(
      (error) {
        emit(state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: error.toString(),
        ));
      },
      (data) {
        emit(state.copyWith(
          isLoading: false,
          verificationCodeSent: true,
          hasError: false,
        ));
      },
    );
  }

  Future<void> _onRefreshTokenRequested(
    RefreshTokenRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _authRepository.refreshToken();

    result.fold(
      (error) {
        emit(state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: error.toString(),
        ));
      },
      (authResponse) {
        emit(state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userData: authResponse.user,
        ));
      },
    );
  }

  Future<void> _onGetProfileRequested(
    GetProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _authRepository.getProfile();

    result.fold(
      (error) {
        emit(state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: error.toString(),
        ));
      },
      (userData) {
        emit(state.copyWith(
          isLoading: false,
          userData: userData,
        ));
      },
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _authRepository.logout();

    result.fold(
      (error) {
        emit(state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: error.toString(),
        ));
      },
      (_) {
        emit(const AuthState()); 
      },
    );
  }

  Future<void> _onCheckUsernameRequested(
    CheckUsernameRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _authRepository.checkUsername(event.username);

    result.fold(
      (error) {
        emit(state.copyWith(
          isLoading: false,
          hasError: true,
          usernameAvailable: false,
        ));
      },
      (response) {
        emit(state.copyWith(
          isLoading: false,
          usernameAvailable: response.available,
        ));
      },
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final isLoggedIn = await _authRepository.isLoggedIn();

    if (isLoggedIn) {
      final result = await _authRepository.getProfile();

      result.fold(
        (error) {
          emit(state.copyWith(
            isLoading: false,
            hasError: true,
            errorMessage: error.toString(),
          ));
        },
        (userData) {
          emit(state.copyWith(
            isLoading: false,
            isAuthenticated: true,
            userData: userData,
          ));
        },
      );
    } else {
      emit(state.copyWith(
        isLoading: false,
        isAuthenticated: false,
      ));
    }
  }
}