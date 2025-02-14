import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_getter_app/core/locators/locators.dart';
import 'package:goal_getter_app/core/route/route_names.dart';
import 'package:goal_getter_app/core/theme/app_color.dart';
import 'package:goal_getter_app/core/utils/app_image_url.dart';
import 'package:goal_getter_app/core/utils/app_string.dart';
import 'package:goal_getter_app/core/utils/custom_snackbar.dart';
import 'package:goal_getter_app/core/utils/full_screen_dialog_loader.dart';
import 'package:goal_getter_app/core/utils/storage_key.dart';
import 'package:goal_getter_app/core/utils/storage_service.dart';
import 'package:goal_getter_app/core/utils/validation_rules.dart';
import 'package:goal_getter_app/core/widgets/custom_text_form_field.dart';
import 'package:goal_getter_app/core/widgets/rounded_elevated_button.dart';
import 'package:goal_getter_app/features/auth/cubit/login_cubit.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final StorageService _storageService = locator<StorageService>();

  bool isPassWordVisible = false;

  clearText() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginLoading) {
                  FullScreenDialogLoader.show(context);
                } else if (state is LoginInSuccess) {
                  clearText();
                  FullScreenDialogLoader.cancel(context);
                  CustomSnackbar.showSuccess(context, AppString.loginSuccess);
                  _storageService.setValue(
                      StorageKey.userId, state.session.userId);

                  _storageService.setValue(
                      StorageKey.sessionId, state.session.$id);
                  context.goNamed(RouteNames.homePage);
                } else if (state is LoginInFailure) {
                  FullScreenDialogLoader.cancel(context);
                  CustomSnackbar.showError(context, state.error);
                }
              },
              builder: (context, state) {
                return Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        Image.asset(
                          AppImageUrl.logo,
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomTextFormField(
                            controller: _emailController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return AppString.required;
                              } else if (!ValidationRules.emailValidation
                                  .hasMatch(val)) {
                                return AppString.provideValidEmail;
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            hintText: AppString.email,
                            suffix: null),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          controller: _passwordController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppString.required;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          maxLines: 1,
                          obscureText: !isPassWordVisible,
                          hintText: AppString.password,
                          suffix: InkWell(
                              onTap: () {
                                setState(() {
                                  isPassWordVisible = !isPassWordVisible;
                                });
                              },
                              child: Icon(
                                isPassWordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColor.greyColor,
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RoundedElevatedButton(
                            buttonText: AppString.login,
                            onPressed: () {
                              if (_loginFormKey.currentState!.validate()) {
                                context.read<LoginCubit>().login(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                              }
                            }),
                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(RouteNames.register);
                          },
                          child: RichText(
                            text: const TextSpan(
                                text: AppString.notRegistered,
                                style: TextStyle(
                                    color: AppColor.greyColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                                children: [
                                  TextSpan(
                                    text: AppString.register,
                                    style: TextStyle(
                                        color: AppColor.appColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  )
                                ]),
                          ),
                        ),
                      ],
                    ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
