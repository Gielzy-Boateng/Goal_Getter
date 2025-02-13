import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_getter_app/core/locators/locators.dart';
import 'package:goal_getter_app/data/repository/auth_repository.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final AuthRepository _authRepository = locator<AuthRepository>();

  LogoutCubit() : super(LogoutInitial());

  void logout() async {
    emit(LogoutLoading());

    final res = await _authRepository.logout();

    res.fold(
      (failure) => emit(
        LogoutError(error: failure.message),
      ),
      (session) => emit(
        LogoutSuccess(),
      ),
    );
  }
}
