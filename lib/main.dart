import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goal_getter_app/core/locators/locators.dart';
import 'package:goal_getter_app/core/route/routes.dart';
import 'package:goal_getter_app/core/theme/app_theme.dart';
import 'package:goal_getter_app/core/utils/app_string.dart';
import 'package:goal_getter_app/features/auth/cubit/login_cubit.dart';
import 'package:goal_getter_app/features/auth/cubit/register_cubit.dart';
import 'package:goal_getter_app/features/goals/cubit/goals_cubit.dart';
import 'package:goal_getter_app/features/splash/cubit/splash_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  setUpLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RegisterCubit()),
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => SplashCubit()),
        BlocProvider(create: (_) => GoalsCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppString.appName,
      theme: AppTheme.darkThemeMode,
      routerConfig: router,
    );
  }
}
