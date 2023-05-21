import 'package:appwrite/appwrite.dart';
import 'package:pmtc/providers.dart';
import 'models.dart';
import 'package:appwrite/models.dart' as model;

Future<model.Account?> currentUserAccount() async {
  final Account account = Account(client);
  try {
    await Future.delayed(const Duration(seconds: 2));
    return await account.get();
  } on AppwriteException {
    return null;
  }
}

Future<List<OurUsers>> getUsers() async {
  final usersList = await gettingAllUsers();
  return usersList.map((e) => OurUsers.fromMap(e.data)).toList();
}

Future<List<model.Document>> gettingAllUsers() async {
  final Databases db = Databases(client);
  final usersList = await db.listDocuments(
    databaseId: 'chat',
    collectionId: 'usera',
    queries: [
      Query.orderDesc('\$updatedAt'),
    ],
  );
  return usersList.documents;
}

Future<List<Message>> getMessages({required String currentChatId}) async {
  final messageList = await gettingMessages(currentChatId: currentChatId);
  return messageList.map((e) => Message.fromMap(e.data)).toList();
}

Future<List<model.Document>> gettingMessages(
    {required String currentChatId}) async {
  print(currentChatId);
  final Databases db = Databases(client);
  final messageList = await db.listDocuments(
    databaseId: 'chat',
    collectionId: currentChatId,
    queries: [
      Query.orderAsc('\$createdAt'),
    ],
  );
  return messageList.documents;
}
