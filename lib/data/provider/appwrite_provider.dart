import 'package:appwrite/appwrite.dart';
import 'package:goal_getter_app/core/utils/appwrite_constants.dart';

class AppwriteProvider {
  Client client = Client();
  Account? account;
  Databases? database;

  AppwriteProvider() {
    client
        .setEndpoint(AppWriteConstants.endpoint)
        .setProject(AppWriteConstants.projectId)
        .setSelfSigned(status: true);
    account = Account(client);
    database = Databases(client);
  }
}
