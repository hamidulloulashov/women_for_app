import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:women_for_app/core/client.dart';
import 'package:women_for_app/features/common/managers/theme_bloc.dart';
final List<SingleChildWidget> dependencies = [
  Provider<ApiClient>(create: (_) => ApiClient()),
    BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc(), 
        ),

 
];
