// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/widgets.dart';
import 'package:goal_getter_app/core/utils/app_string.dart';
import 'package:goal_getter_app/core/utils/custom_snackbar.dart';
import 'package:goal_getter_app/core/utils/full_screen_dialog_loader.dart';
import 'package:goal_getter_app/core/widgets/custom_text_form_field.dart';
import 'package:goal_getter_app/core/widgets/rounded_elevated_button.dart';
import 'package:goal_getter_app/features/goals/cubit/goals_cubit.dart';
// import 'package:goal_getter_app/main.dart';

class AddEditGoalsView extends StatefulWidget {
  const AddEditGoalsView({super.key});

  @override
  State<AddEditGoalsView> createState() => _AddEditGoalsViewState();
}

class _AddEditGoalsViewState extends State<AddEditGoalsView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleEditingController,
      _descriptionEditingController;
  late bool isCompleted;

  @override
  void initState() {
    _titleEditingController = TextEditingController();
    _descriptionEditingController = TextEditingController();
    isCompleted = false;
    super.initState();
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _descriptionEditingController.dispose();
    super.dispose();
  }

  clearText() {
    _titleEditingController.clear();
    _descriptionEditingController.clear();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final title = _titleEditingController.text;
      final description = _descriptionEditingController.text;
      context
          .read<GoalsCubit>()
          .addGoal(title: title, description: description, isCompleted: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.addTodo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<GoalsCubit, GoalsState>(
          listener: (context, state) {
            if (state is GoalsAddEditDeleteLoading) {
              FullScreenDialogLoader.show(context);
            } else if (state is GoalsAddEditDeleteSuccess) {
              FullScreenDialogLoader.cancel(context);
              clearText();
              CustomSnackbar.showSuccess(context, AppString.todoCreated);
            } else if (state is GoalsError) {
              FullScreenDialogLoader.cancel(context);
              CustomSnackbar.showError(context, state.error);
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                      controller: _titleEditingController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return AppString.required;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      hintText: AppString.title,
                      suffix: null),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                      controller: _descriptionEditingController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return AppString.required;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      hintText: AppString.description,
                      suffix: null),
                  const SizedBox(
                    height: 10,
                  ),
                  RoundedElevatedButton(
                      buttonText: AppString.add,
                      onPressed: () {
                        _submit();
                      })
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
