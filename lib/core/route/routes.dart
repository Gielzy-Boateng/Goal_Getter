import 'package:go_router/go_router.dart';
import 'package:goal_getter_app/core/route/route_names.dart';
import 'package:goal_getter_app/features/auth/view/login_view.dart';
import 'package:goal_getter_app/features/auth/view/register_view.dart';
import 'package:goal_getter_app/features/splash/view/splashview.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/',
    name: RouteNames.splash,
    builder: (context, state) => const SplashView(),
  ),
  GoRoute(
    path: '/login',
    name: RouteNames.login,
    builder: (context, state) => const LoginView(),
  ),
  GoRoute(
    path: '/register',
    name: RouteNames.register,
    builder: (context, state) => const RegisterView(),
  ),
]);
