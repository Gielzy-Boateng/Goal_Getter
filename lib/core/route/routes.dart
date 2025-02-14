import 'package:go_router/go_router.dart';
import 'package:goal_getter_app/core/route/route_names.dart';
import 'package:goal_getter_app/data/model/goals_model.dart';
import 'package:goal_getter_app/features/auth/view/login_view.dart';
import 'package:goal_getter_app/features/auth/view/register_view.dart';
import 'package:goal_getter_app/features/goals/view/add_edit_goals_view.dart';
import 'package:goal_getter_app/features/goals/view/goals_view.dart';
import 'package:goal_getter_app/features/profile/profile_view.dart';
import 'package:goal_getter_app/features/splash/view/home_page.dart';
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
  GoRoute(
    path: '/goals',
    name: RouteNames.goals,
    builder: (context, state) => const GoalsView(),
  ),
  GoRoute(
    path: '/addGoals',
    name: RouteNames.addGoals,
    builder: (context, state) => const AddEditGoalsView(),
  ),
  GoRoute(
    path: '/profileView',
    name: RouteNames.profileView,
    builder: (context, state) => const ProfileView(),
  ),
  GoRoute(
    path: '/homePage',
    name: RouteNames.homePage,
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
      path: '/editGoal',
      name: RouteNames.editGoal,
      builder: (context, state) {
        final goalsModel = state.extra as GoalsModel;
        return AddEditGoalsView(goalsModel: goalsModel);
        //  const AddEditGoalsView();
      }),
]);
