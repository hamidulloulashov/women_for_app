import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_for_app/core/client.dart';
import 'package:women_for_app/data/repositories/user_repository.dart';
import 'package:women_for_app/features/common/widgets/app_bar_widget.dart';
import 'package:women_for_app/features/home/managers/userBloc/user_bloc.dart';
import 'package:women_for_app/features/home/managers/userBloc/user_state.dart';
import 'package:women_for_app/core/utils/status.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(
        userRepository: UserRepository(
          client: ApiClient(),
        ),
      )..add(FetchUser()),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          if (userState.status == Status.loading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (userState.status == Status.error) {
            return Scaffold(
              body: Center(
                child: Text('Xato: ${userState.errorMessage}'),
              ),
            );
          }

          if (userState.status == Status.success && userState.user != null) {
            return Scaffold(
              appBar: AppBarWidget(
                title: Text(userState.user!.email),
              ),
              body: Center(
                child: Text('Xush kelibsiz, ${userState.user!.fullName ?? "Foydalanuvchi"}'),
              ),
            );
          }

          return const Scaffold(
            body: Center(child: Text("Ma'lumot yuklanmoqda...")),
          );
        },
      ),
    );
  }
}
