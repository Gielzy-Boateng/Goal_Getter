import 'package:get_it/get_it.dart';
import 'package:goal_getter_app/core/utils/storage_service.dart';
import 'package:goal_getter_app/data/provider/appwrite_provider.dart';
import 'package:goal_getter_app/data/repository/auth_repository.dart';
import 'package:goal_getter_app/data/repository/goals_repository.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final locator = GetIt.I;

void setUpLocator() {
  locator.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(),
  );

  locator.registerLazySingleton<AppwriteProvider>(
    () => AppwriteProvider(),
  );

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepository(),
  );

  locator.registerLazySingleton<GoalsRepository>(
    () => GoalsRepository(),
  );

  locator.registerLazySingleton<StorageService>(
    () => StorageService(),
  );
}
