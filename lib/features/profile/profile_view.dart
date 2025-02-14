import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_getter_app/core/route/route_names.dart';
// import 'package:goal_getter_app/core/route/routes.dart';
import 'package:goal_getter_app/core/theme/app_color.dart';
import 'package:goal_getter_app/core/utils/app_image_url.dart';
import 'package:goal_getter_app/core/utils/app_string.dart';
import 'package:goal_getter_app/core/utils/custom_snackbar.dart';
// import 'package:goal_getter_app/core/utils/full_screen_dialog_loader.dart';
// import 'package:goal_getter_app/core/widgets/rounded_elevated_button.dart';
import 'package:goal_getter_app/features/auth/cubit/get_user_cubit.dart';
import 'package:goal_getter_app/features/auth/cubit/logout_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  void _launchUrl(BuildContext context) async {
    final Uri url = Uri.parse('https://desmond-code.vercel.app');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    } else {
      if (!context.mounted) return;

      CustomSnackbar.showError(context, 'Could not lauch the website');
    }
  }

  void _logout() {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.question,
        animType: AnimType.rightSlide,
        title: AppString.logout,
        desc: AppString.areYouSureYouWantToLogOut,
        btnCancelOnPress: () {},
        btnOkText: 'Yes',
        btnOkOnPress: () {
          context.read<LogoutCubit>().logout();
          context.goNamed(RouteNames.login);
        }).show();
  }

  @override
  void initState() {
    context.read<GetUserCubit>().fetchUser();
    super.initState();
  }

  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.profile),
        backgroundColor: AppColor.appBarColor,
        actions: [
          // IconButton(onPressed: () {}, icon: const Icon(Icons.exit_to_app)),
          // RoundedElevatedButton(buttonText: AppString.logout, onPressed: () {}),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                onPressed: () {
                  _logout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background color
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5), // Button padding
                  textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold), // Text styling
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13), // Rounded corners
                  ),
                  elevation: 5, // Shadow effect
                ),
                child: const Text(AppString.logout)),
          )
        ],
      ),
      body: BlocBuilder<GetUserCubit, GetUserState>(
        builder: (context, state) {
          if (state is GetUserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetUserSuccess) {
            final user = state.user;

            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'About Me',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user.profileImage != null &&
                            user.profileImage!.isNotEmpty
                        ? NetworkImage(user.profileImage!) as ImageProvider
                        : const AssetImage(AppImageUrl.defaultIimage),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    textAlign: TextAlign.center,
                    'Every day is a new chance to be better than yesterday. 🔄',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Have a great day,',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.firstName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        user.lastName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  // const Text('Designed by Juizy code'),
                  const Text(
                    '\u00A9 2025 \u2022 Designed by JuizyCode',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  MouseRegion(
                    onEnter: (_) => setState(() {
                      isHovered = true;
                    }),
                    onExit: (_) => setState(() {
                      isHovered = false;
                    }),
                    child: TextButton(
                      onPressed: () {
                        _launchUrl(context);
                      },
                      child: Text(
                        'Visit our website @Juizycode.com',
                        style: TextStyle(
                            color: isHovered ? Colors.blue : Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (state is GetUserFailure) {
            CustomSnackbar.showError(context, state.error);
          }

          return Container();
        },
      ),
    );
  }
}
