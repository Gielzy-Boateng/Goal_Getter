import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_getter_app/core/locators/locators.dart';
import 'package:goal_getter_app/core/utils/storage_key.dart';
import 'package:goal_getter_app/core/utils/storage_service.dart';
import 'package:goal_getter_app/data/model/user_model.dart';
import 'package:goal_getter_app/data/repository/auth_repository.dart';

part 'get_user_state.dart';

final AuthRepository _authRepository = locator<AuthRepository>();

final StorageService _storageService = locator<StorageService>();

class GetUserCubit extends Cubit<GetUserState> {
  GetUserCubit() : super(GetUserInitial());

  void fetchUser() async {
    emit(GetUserLoading());

    final res = await _authRepository.fetchUserDetails(
        userId: _storageService.getValue(StorageKey.userId));

    res.fold(
        (failure) => emit(
              GetUserFailure(error: failure.message),
            ),
        (user) => emit(
              GetUserSuccess(user: user),
            ));
  }
}
