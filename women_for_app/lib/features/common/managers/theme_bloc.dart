import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

class LoadThemeEvent extends ThemeEvent {}

class ThemeState {
  final ThemeMode themeMode;

  ThemeState({required this.themeMode});

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }

  bool get isDark => themeMode == ThemeMode.dark;
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const _themeKey = "theme_mode";

  ThemeBloc() : super(ThemeState(themeMode: ThemeMode.light)) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<LoadThemeEvent>(_onLoadTheme);

    add(LoadThemeEvent());
  }

  Future<void> _onToggleTheme(
      ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    final newTheme = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    emit(state.copyWith(themeMode: newTheme));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _themeKey, newTheme == ThemeMode.dark ? "dark" : "light");
  }

  Future<void> _onLoadTheme(
      LoadThemeEvent event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey) ?? "light";
    final themeMode =
        themeString == "dark" ? ThemeMode.dark : ThemeMode.light;
    emit(state.copyWith(themeMode: themeMode));
  }
}
