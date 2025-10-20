import 'package:go_router/go_router.dart';
import 'package:women_for_app/core/router/routes.dart';
import 'package:women_for_app/features/auth/pages/login_page.dart';
import 'package:women_for_app/features/auth/pages/register_page.dart';
import 'package:women_for_app/features/auth/pages/splash_page.dart';
import 'package:women_for_app/features/home/pages/home_page.dart';

final GoRouter router = GoRouter(
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: Routes.homePage,
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: Routes.register,
      builder: (context, state) => RegisterPage(),
    ),
  ],
);
