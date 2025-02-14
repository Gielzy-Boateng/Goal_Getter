import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_getter_app/core/route/route_names.dart';
import 'package:goal_getter_app/core/route/routes.dart';
import 'package:goal_getter_app/core/theme/app_color.dart';
import 'package:goal_getter_app/core/utils/custom_snackbar.dart';
import 'package:goal_getter_app/core/widgets/rounded_elevated_button.dart';
import 'package:goal_getter_app/features/auth/cubit/get_user_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<GetUserCubit>().fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Getter App'),
        backgroundColor: AppColor.appBarColor,
      ),
      body: BlocBuilder<GetUserCubit, GetUserState>(
        builder: (context, state) {
          if (state is GetUserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetUserSuccess) {
            final user = state.user;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Welcome, ${user.firstName.toUpperCase()} 😊',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  const Text(
                    'Your journey starts here! 🚀 ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  const Text(
                    'Dream it. Plan it. Achieve it. 🎯',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  const Text(
                    'Set goals. Track progress.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  const Text(
                    "Click 'Vision Board' to get started! ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                      foregroundColor: Colors.white, // Text color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10), // Button padding
                      textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold), // Text styling
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(13), // Rounded corners
                      ),
                      elevation: 5, // Shadow effect
                    ),
                    onPressed: () {
                      context.goNamed(RouteNames.goals);
                    },
                    child: const Text(
                      'View Vision Board',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  )
                  // RoundedElevatedButton(

                  //     buttonText: 'Vision Board', onPressed: () {},)
                ],
              ),
            );
          } else if (state is GetUserFailure) {
            CustomSnackbar.showError(context, state.error);
          }

          return const Text('');
        },
      ),
    );
  }
}
