part of 'get_user_cubit.dart';

sealed class GetUserState {}

final class GetUserInitial extends GetUserState {}

final class GetUserLoading extends GetUserState {}

final class GetUserSuccess extends GetUserState {
  final UserModel user;
  GetUserSuccess({required this.user});
}

final class GetUserFailure extends GetUserState {
  final String error;
  GetUserFailure({required this.error});
}
// final class GetUserInitial extends GetUserState {}
