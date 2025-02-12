import 'package:appwrite/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_getter_app/core/locators/locators.dart';
import 'package:goal_getter_app/data/repository/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository = locator<AuthRepository>();

  LoginCubit() : super(LoginInitial());

  void login({required String email, required String password}) async {
    emit(LoginLoading());

    final res = await _authRepository.login(email: email, password: password);

    res.fold(
      (failure) => emit(
        LoginInFailure(error: failure.message),
      ),
      (session) => emit(
        LoginInSuccess(session: session),
      ),
    );
  }
}
