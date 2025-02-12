import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_getter_app/core/route/route_names.dart';
// import 'package:goal_getter_app/core/route/routes.dart';
// import 'package:go_router/go_router.dart';
// import 'package:goal_getter_app/core/route/route_names.dart';
// import 'package:goal_getter_app/core/route/routes.dart';
import 'package:goal_getter_app/core/utils/app_image_url.dart';
import 'package:goal_getter_app/core/utils/custom_snackbar.dart';
import 'package:goal_getter_app/core/utils/full_screen_dialog_loader.dart';
// import 'package:goal_getter_app/features/auth/cubit/login_cubit.dart';
import 'package:goal_getter_app/features/splash/cubit/splash_cubit.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashCubit>().checkSession();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state is SplashLoading) {
              FullScreenDialogLoader.show(context);
            }
            if (state is SplashSuccess) {
              FullScreenDialogLoader.cancel(context);
              context.goNamed(RouteNames.goals);
            }
            if (state is SplashError) {
              FullScreenDialogLoader.cancel(context);
              context.goNamed(RouteNames.login);
              CustomSnackbar.showError(context, state.error);
            }
          },
          builder: (context, state) {
            return Image.asset(
              AppImageUrl.logo,
              width: 150,
              height: 150,
            );
          },
        ),
      ),
    );
  }
}
