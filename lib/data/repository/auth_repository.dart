import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:goal_getter_app/core/error/failure.dart';
import 'package:goal_getter_app/core/error/server_exception.dart';
import 'package:goal_getter_app/core/locators/locators.dart';
import 'package:goal_getter_app/core/utils/app_string.dart';
import 'package:goal_getter_app/core/utils/appwrite_constants.dart';
import 'package:goal_getter_app/data/model/user_model.dart';
import 'package:goal_getter_app/data/provider/appwrite_provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, User>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<Either<Failure, Session>> login({
    required String email,
    required String password,
  });
  Future<Either<Failure, UserModel>> fetchUserDetails({
    required String userId,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, Session>> checkSession();
}

class AuthRepository implements IAuthRepository {
  final AppwriteProvider _appwriteProvider = locator<AppwriteProvider>();
  final InternetConnectionChecker _internetConnectionChecker =
      locator<InternetConnectionChecker>();

//register session
  @override
  Future<Either<Failure, User>> register(
      {required String firstName,
      required String lastName,
      required String email,
      required String password}) async {
    try {
      if (await _internetConnectionChecker.hasConnection) {
        User user = await _appwriteProvider.account!.create(
            userId: ID.unique(),
            email: email,
            password: password,
            name: "$firstName $lastName");

        await _appwriteProvider.database!.createDocument(
            databaseId: AppWriteConstants.databaseId,
            collectionId: AppWriteConstants.userCollectionId,
            documentId: user.$id,
            data: {
              "id": user.$id,
              "first_name": firstName,
              "last_name": lastName,
              "full_name": "$firstName $lastName",
              "email": email
            });

        return right(user);
      } else {
        return left(Failure(AppString.internetNotFound));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

//Login session
  @override
  Future<Either<Failure, Session>> login(
      {required String email, required String password}) async {
    try {
      if (await _internetConnectionChecker.hasConnection) {
        Session session =
            await _appwriteProvider.account!.createEmailPasswordSession(
          email: email,
          password: password,
        );

        return right(session);
      } else {
        return left(Failure(AppString.internetNotFound));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

//check session
  @override
  Future<Either<Failure, Session>> checkSession() async {
    try {
      if (await _internetConnectionChecker.hasConnection) {
        Session session =
            await _appwriteProvider.account!.getSession(sessionId: 'current');

        return right(session);
      } else {
        return left(Failure(AppString.internetNotFound));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

//logout
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      if (await _internetConnectionChecker.hasConnection) {
        await _appwriteProvider.account!.deleteSession(sessionId: 'current');

        return right(null);
      } else {
        return left(Failure(AppString.internetNotFound));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

//getUser
  @override
  Future<Either<Failure, UserModel>> fetchUserDetails(
      {required String userId}) async {
    try {
      if (await _internetConnectionChecker.hasConnection) {
        Document userDocument = await _appwriteProvider.database!.getDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.userCollectionId,
          documentId: userId, // Assuming userId is used as document ID
        );

        UserModel user = UserModel.fromMap(userDocument.data);
        // print(user.email);
        // print(user.firstName);
        // print(user.lastName);
        return right(user);
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
