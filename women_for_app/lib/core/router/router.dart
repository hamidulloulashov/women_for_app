import 'package:go_router/go_router.dart';
import 'package:women_for_app/core/router/routes.dart';
import 'package:women_for_app/features/auth/pages/splash_page.dart';

final GoRouter router = GoRouter(
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashPage(),
    ),
   
    ],
  );

