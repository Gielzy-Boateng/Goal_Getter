import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:goal_getter_app/core/error/failure.dart';
import 'package:goal_getter_app/core/error/server_exception.dart';
import 'package:goal_getter_app/core/locators/locators.dart';
import 'package:goal_getter_app/core/utils/app_string.dart';
import 'package:goal_getter_app/core/utils/appwrite_constants.dart';
import 'package:goal_getter_app/data/model/goals_model.dart';
import 'package:goal_getter_app/data/provider/appwrite_provider.dart';
// import 'package:goal_getter_app/data/repository/auth_repository.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract interface class IGoalsRepository {
  Future<Either<Failure, Document>> addGoal(
      {required String userId,
      required String title,
      required String description,
      required bool isCompleted});

  Future<Either<Failure, Document>> editGoal(
      {required String documentId,
      required String title,
      required String description,
      required bool isCompleted});

  Future<Either<Failure, List<GoalsModel>>> fetchGoal({required String userId});
}

class GoalsRepository implements IGoalsRepository {
  final AppwriteProvider _appwriteProvider = locator<AppwriteProvider>();
  final InternetConnectionChecker _internetConnectionChecker =
      locator<InternetConnectionChecker>();

  @override
  Future<Either<Failure, Document>> addGoal(
      {required String userId,
      required String title,
      required String description,
      required bool isCompleted}) async {
    try {
      String documentId = ID.unique();
      if (await _internetConnectionChecker.hasConnection) {
        Document document = await _appwriteProvider.database!.createDocument(
            databaseId: AppWriteConstants.databaseId,
            collectionId: AppWriteConstants.todoCollectionId,
            documentId: documentId,
            data: {
              'userId': userId,
              "title": title,
              "description": description,
              "isCompleted": isCompleted,
              'id': documentId
            });
        return right(document);
      } else {
        return left(Failure(AppString.internetNotFound));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<GoalsModel>>> fetchGoal({
    required String userId,
  }) async {
    try {
      if (await _internetConnectionChecker.hasConnection) {
        DocumentList list = await _appwriteProvider.database!.listDocuments(
            databaseId: AppWriteConstants.databaseId,
            collectionId: AppWriteConstants.todoCollectionId,
            queries: [Query.equal('userId', userId)]);

        Map<String, dynamic> data = list.toMap();
        List d = data['documents'].toList();

        List<GoalsModel> goalsList =
            d.map((e) => GoalsModel.fromMap(e['data'])).toList();
        return right(goalsList);
      } else {
        return left(Failure(AppString.internetNotFound));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Document>> editGoal(
      {required String documentId,
      required String title,
      required String description,
      required bool isCompleted}) async {
    try {
      if (await _internetConnectionChecker.hasConnection) {
        Document document = await _appwriteProvider.database!.updateDocument(
            databaseId: AppWriteConstants.databaseId,
            collectionId: AppWriteConstants.todoCollectionId,
            documentId: documentId,
            data: {
              "title": title,
              "description": description,
              "isCompleted": isCompleted,
            });
        return right(document);
      } else {
        return left(Failure(AppString.internetNotFound));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
