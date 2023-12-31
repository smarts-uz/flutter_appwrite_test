// ignore_for_file: prefer_final_fields

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite_test/appwrite/auth_api.dart';
import 'package:appwrite_test/constants/constants.dart';
import 'package:flutter/material.dart';

class DatatbaseApi extends ChangeNotifier {
  Client client = Client();
  late final Account account;
  late final Databases databases;
  final AuthApi authApi = AuthApi();

  DatatbaseApi() {
    init();
  }

  init() {
    client
        .setEndpoint(APPWRITE_URL)
        .setProject(APPWRITE_PROJECT_ID)
        .setSelfSigned();
    account = Account(client);
    databases = Databases(client);
  }

  Future<DocumentList> getMessages() {
    return databases.listDocuments(
      databaseId: APPWRITE_DATABASE_ID,
      collectionId: COLLECTION_MESSAGES_ID,
    );
  }

  Future<DocumentList> getNumbers(int pageKey, int pageSize) {
    return databases.listDocuments(
      databaseId: APPWRITE_DATABASE_ID,
      collectionId: COLLECTION_NUMBERS_ID,
      queries: [
        Query.limit(pageSize),
        Query.offset(pageKey),
      ],
    );
  }

  Future<Document> addMessage(String message) {
    return databases.createDocument(
      databaseId: APPWRITE_DATABASE_ID,
      collectionId: COLLECTION_MESSAGES_ID,
      documentId: ID.unique(),
      data: {
        'text': message,
        'date': DateTime.now().toString(),
        'user_id': authApi.userId,
      },
    );
  }

  Future<dynamic> deleteMessage(String id) {
    return databases.deleteDocument(
      databaseId: APPWRITE_DATABASE_ID,
      collectionId: COLLECTION_MESSAGES_ID,
      documentId: id,
    );
  }
}
