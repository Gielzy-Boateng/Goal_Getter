part of 'login_cubit.dart';

sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginInSuccess extends LoginState {
  final Session session;
  LoginInSuccess({required this.session});
}

final class LoginInFailure extends LoginState {
  final String error;
  LoginInFailure({required this.error});
}
