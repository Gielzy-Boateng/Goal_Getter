// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_getter_app/core/route/route_names.dart';
import 'package:goal_getter_app/core/theme/app_color.dart';
import 'package:goal_getter_app/core/utils/app_string.dart';
import 'package:goal_getter_app/features/goals/cubit/goals_cubit.dart';

class GoalsView extends StatefulWidget {
  const GoalsView({super.key});

  @override
  State<GoalsView> createState() => _GoalsViewState();
}

class _GoalsViewState extends State<GoalsView> {
  @override
  void initState() {
    context.read<GoalsCubit>().fetchGoals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.goals),
        backgroundColor: AppColor.appBarColor,
        actions: [
          IconButton(
              onPressed: () {
                //move to profile screen
              },
              icon: const Icon(Icons.person))
        ],
      ),
      body: BlocBuilder<GoalsCubit, GoalsState>(
        builder: (context, state) {
          if (state is GoalsFetchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GoalsFetchSuccess) {
            final goals = state.goalsModel;
            return goals.isNotEmpty
                ? ListView.builder(
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      final goal = goals[index];
                      return ListTile(
                        onTap: () =>
                            context.pushNamed(RouteNames.editGoal, extra: goal),
                        title: Text(goal.title),
                        subtitle: Text(goal.description),
                        leading: CircleAvatar(
                          radius: 10,
                          backgroundColor: goal.isCompleted
                              ? AppColor.snackBarGreen
                              : AppColor.snackBarRed,
                        ),
                      );
                    },
                  )
                : const Text(AppString.noDataFound);
          } else if (state is GoalsError) {
            return Text(state.error);
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(RouteNames.addGoals);
        },
        backgroundColor: AppColor.appColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
