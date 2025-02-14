part of 'goals_cubit.dart';

sealed class GoalsState {}

final class GoalsInitial extends GoalsState {}

final class GoalsAddEditDeleteLoading extends GoalsState {}

final class GoalsFetchLoading extends GoalsState {}

final class GoalsAddEditDeleteSuccess extends GoalsState {
  final bool isDeleted;
  GoalsAddEditDeleteSuccess({this.isDeleted = false});
}

final class GoalsFetchSuccess extends GoalsState {
  final List<GoalsModel> goalsModel;
  GoalsFetchSuccess({required this.goalsModel});
}

final class GoalsError extends GoalsState {
  final String error;
  GoalsError({required this.error});
}
