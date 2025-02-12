import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_getter_app/core/locators/locators.dart';
import 'package:goal_getter_app/data/repository/auth_repository.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  final AuthRepository _authRepository = locator<AuthRepository>();

  void checkSession() async {
    emit(SplashInitial());

    final res = await _authRepository.checkSession();

    res.fold((failure) => emit(SplashError(error: failure.message)),
        (session) => emit(SplashSuccess()));
  }
}
