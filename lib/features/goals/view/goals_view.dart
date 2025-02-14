// import 'package:flutter/foundation.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_getter_app/core/route/route_names.dart';
import 'package:goal_getter_app/core/theme/app_color.dart';
import 'package:goal_getter_app/core/utils/app_string.dart';
// import 'package:goal_getter_app/features/auth/cubit/logout_cubit.dart';
import 'package:goal_getter_app/features/goals/cubit/goals_cubit.dart';

class GoalsView extends StatefulWidget {
  const GoalsView({super.key});

  @override
  State<GoalsView> createState() => _GoalsViewState();
}

class _GoalsViewState extends State<GoalsView> {
  // final Random random = Random();

  // Color getRandomColor() {
  //   return Color.fromARGB(
  //     255,
  //     random.nextInt(256),
  //     random.nextInt(256),
  //     random.nextInt(256),
  //   );
  // }

  // Color getTextColor(Color backgroundColor) {
  //   double luminance =
  //       backgroundColor.computeLuminance(); // 0 (dark) to 1 (light)
  //   return luminance > 0.5
  //       ? Colors.black
  //       : Colors.white; // Light bg → black text, Dark bg → white text
  // }

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
              context.read<GoalsCubit>().fetchGoals();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              context.pushNamed(RouteNames.profileView);
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: BlocBuilder<GoalsCubit, GoalsState>(
        builder: (context, state) {
          if (state is GoalsFetchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GoalsFetchSuccess) {
            final goals = state.goalsModel;
            return goals.isNotEmpty
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListView.separated(
                      itemCount: goals.length,
                      itemBuilder: (context, index) {
                        final goal = goals[index];

                        // Generate random background color

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: index.isEven
                                ? const Color(0xFF474787)
                                : const Color(0xFF2C2C54),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 20),
                          child: ListTile(
                            onTap: () => context.pushNamed(RouteNames.editGoal,
                                extra: goal),
                            title: Column(
                              children: [
                                Text(goal.title.toUpperCase(),
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,

                                          // color: AppColor.appColor,
                                        )),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                            subtitle: Text(
                              goal.description,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            leading: CircleAvatar(
                              radius: 10,
                              backgroundColor: goal.isCompleted
                                  ? AppColor.snackBarGreen
                                  : AppColor.snackBarRed,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: AppColor.whiteColor,
                          thickness: 0.5,
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Text(
                    AppString.noDataFound,
                    style: TextStyle(
                        // color: AppColor.snackBarRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ));
          } else if (state is GoalsError) {
            return Center(
                child: Text(
              "${state.error} ⚠️",
              style: const TextStyle(
                  // color: AppColor.snackBarRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ));
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
