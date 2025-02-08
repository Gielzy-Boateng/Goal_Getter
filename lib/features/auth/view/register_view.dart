import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_getter_app/core/route/route_names.dart';
import 'package:goal_getter_app/core/theme/app_color.dart';
import 'package:goal_getter_app/core/utils/app_image_url.dart';
import 'package:goal_getter_app/core/utils/app_string.dart';
import 'package:goal_getter_app/core/utils/validation_rules.dart';
import 'package:goal_getter_app/core/widgets/custom_text_form_field.dart';
import 'package:goal_getter_app/core/widgets/rounded_elevated_button.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPassWordVisible = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
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
            child: Form(
                key: _registerFormKey,
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
                        controller: _firstNameController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return AppString.required;
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        obscureText: false,
                        hintText: AppString.firstName,
                        suffix: null),
                    const SizedBox(
                      height: 10,
                    ),

                    //lastName
                    CustomTextFormField(
                        controller: _lastNameController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return AppString.required;
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        obscureText: false,
                        hintText: AppString.lastName,
                        suffix: null),
                    const SizedBox(
                      height: 10,
                    ),

                    //email
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
                        buttonText: AppString.register,
                        onPressed: () {
                          if (_registerFormKey.currentState!.validate()) {}
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(RouteNames.login);
                      },
                      child: RichText(
                        text: const TextSpan(
                            text: AppString.loggedIn,
                            style: TextStyle(
                                color: AppColor.greyColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                            children: [
                              TextSpan(
                                  text: AppString.login,
                                  style: TextStyle(
                                      color: AppColor.appColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16))
                            ]),
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
