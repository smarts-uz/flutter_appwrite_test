import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';

class AppwriteClient {
  static Client client = Client();

  Account account = Account(client);

  // Register User
  Future<User?> signup({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      return user;
    } on AppwriteException catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
