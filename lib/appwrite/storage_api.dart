// ignore_for_file: prefer_final_fields

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite_test/appwrite/auth_api.dart';
import 'package:appwrite_test/constants/constants.dart';
import 'package:flutter/material.dart';

class StorageApi extends ChangeNotifier {
  Client client = Client();
  late final Account account;
  late final Storage storage;
  final AuthApi authApi = AuthApi();

  StorageApi() {
    init();
  }

  init() {
    client
        .setEndpoint(APPWRITE_URL)
        .setProject(APPWRITE_PROJECT_ID)
        .setSelfSigned();
    account = Account(client);
    storage = Storage(client);
  }

  Future<FileList> getImages() {
    return storage.listFiles(
      bucketId: IMAGES_BUCKET_ID,
    );
  }

  Future getFileView(String fileId) async {
    var result = storage.getFileView(
      bucketId: IMAGES_BUCKET_ID,
      fileId: fileId,
    );
    return result;
  }
}
