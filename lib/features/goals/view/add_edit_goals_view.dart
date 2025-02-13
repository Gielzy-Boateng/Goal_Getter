// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_getter_app/core/route/routes.dart';
import 'package:goal_getter_app/core/theme/app_color.dart';
// import 'package:flutter/widgets.dart';
import 'package:goal_getter_app/core/utils/app_string.dart';
import 'package:goal_getter_app/core/utils/custom_snackbar.dart';
import 'package:goal_getter_app/core/utils/full_screen_dialog_loader.dart';
import 'package:goal_getter_app/core/widgets/custom_text_form_field.dart';
import 'package:goal_getter_app/core/widgets/rounded_elevated_button.dart';
import 'package:goal_getter_app/data/model/goals_model.dart';
import 'package:goal_getter_app/features/goals/cubit/goals_cubit.dart';
// import 'package:goal_getter_app/main.dart';

class AddEditGoalsView extends StatefulWidget {
  final GoalsModel? goalsModel;
  const AddEditGoalsView({super.key, this.goalsModel});

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
    _titleEditingController =
        TextEditingController(text: widget.goalsModel?.title ?? '');
    _descriptionEditingController =
        TextEditingController(text: widget.goalsModel?.description ?? '');
    isCompleted = widget.goalsModel?.isCompleted ?? false;
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

      if (widget.goalsModel == null) {
        context.read<GoalsCubit>().addGoal(
            title: title, description: description, isCompleted: false);
      } else {
        context.read<GoalsCubit>().editGoal(
            documentId: widget.goalsModel!.id,
            title: title,
            description: description,
            isCompleted: isCompleted);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.goalsModel == null ? AppString.addTodo : AppString.editTodo),
        actions: [
          if (widget.goalsModel != null)
            IconButton(
                onPressed: () {
                  //delete goal
                },
                icon: const Icon(
                  Icons.delete,
                  color: AppColor.whiteColor,
                ))
        ],
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
              if (widget.goalsModel == null) {
                CustomSnackbar.showSuccess(context, AppString.todoCreated);
              } else {
                CustomSnackbar.showSuccess(context, AppString.todoUpdated);
              }
              context.pop();
              context.read<GoalsCubit>().fetchGoals();
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
                  if (widget.goalsModel != null)
                    Checkbox(
                      value: isCompleted,
                      onChanged: (value) {
                        setState(() {
                          isCompleted = value!;
                        });
                      },
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  RoundedElevatedButton(
                      buttonText: widget.goalsModel == null
                          ? AppString.add
                          : AppString.update,
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
