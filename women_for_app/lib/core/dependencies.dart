import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:women_for_app/core/client.dart';
import 'package:women_for_app/data/repositories/aut_repository.dart';
import 'package:women_for_app/features/auth/managers/aut_bloc.dart';
import 'package:women_for_app/features/auth/managers/auth_event.dart';
import 'package:women_for_app/features/common/managers/theme_bloc.dart';

final List<SingleChildWidget> dependencies = [
  // API Client
  Provider<ApiClient>(create: (_) => ApiClient()),
  
  // Repositories
  ProxyProvider<ApiClient, AuthRepository>(
    update: (_, apiClient, __) => AuthRepository(apiClient),
  ),
  
  // BLoCs
  BlocProvider<ThemeBloc>(
    create: (_) => ThemeBloc(),
  ),
  
  BlocProvider<AuthBloc>(
    create: (context) => AuthBloc(
      context.read<AuthRepository>(),
    )..add(CheckAuthStatus()),
  ),
];