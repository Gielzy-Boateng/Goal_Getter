import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_getter_app/core/locators/locators.dart';
import 'package:goal_getter_app/core/utils/storage_key.dart';
import 'package:goal_getter_app/core/utils/storage_service.dart';
import 'package:goal_getter_app/data/model/goals_model.dart';
import 'package:goal_getter_app/data/repository/goals_repository.dart';

part 'goals_state.dart';

class GoalsCubit extends Cubit<GoalsState> {
  GoalsCubit() : super(GoalsInitial());

  final GoalsRepository _goalsRepository = locator<GoalsRepository>();

  final StorageService _storageService = locator<StorageService>();

  void addGoal(
      {required String title,
      required String description,
      required bool isCompleted}) async {
    emit(GoalsAddEditDeleteLoading());

    final res = await _goalsRepository.addGoal(
        userId: _storageService.getValue(StorageKey.userId),
        title: title,
        description: description,
        isCompleted: isCompleted);

    res.fold((failure) => emit(GoalsError(error: failure.message)),
        (document) => emit(GoalsAddEditDeleteSuccess()));
  }

  void fetchGoals() async {
    emit(GoalsFetchLoading());

    final res = await _goalsRepository.fetchGoal(
        userId: _storageService.getValue(StorageKey.userId));

    res.fold((failure) => emit(GoalsError(error: failure.message)),
        (goalsModel) => emit(GoalsFetchSuccess(goalsModel: goalsModel)));
  }

  void editGoal(
      {required String documentId,
      required String title,
      required String description,
      required bool isCompleted}) async {
    emit(GoalsAddEditDeleteLoading());

    final res = await _goalsRepository.editGoal(
        documentId: documentId,
        title: title,
        description: description,
        isCompleted: isCompleted);

    res.fold((failure) => emit(GoalsError(error: failure.message)),
        (document) => emit(GoalsAddEditDeleteSuccess()));
  }
}
