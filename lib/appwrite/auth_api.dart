// ignore_for_file: prefer_final_fields

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite_test/constants/constants.dart';
import 'package:flutter/material.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  unauthenticated,
}

class AuthApi extends ChangeNotifier {
  Client client = Client();
  late final Account account;
  late User _currentUser;
  AuthStatus _status = AuthStatus.uninitialized;

  /// Getters
  User get user => _currentUser;
  AuthStatus get status => _status;
  String get userName => _currentUser.name;
  String get email => _currentUser.email;
  String get userId => _currentUser.$id;

  AuthApi() {
    init();
    loadUser();
  }

  init() {
    client
        .setEndpoint(APPWRITE_URL)
        .setProject(APPWRITE_PROJECT_ID)
        .setSelfSigned();
    account = Account(client);
  }

  loadUser() async {
    try {
      final user = await account.get();
      _status = AuthStatus.authenticated;
      _currentUser = user;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    } finally {
      notifyListeners();
    }
  }

  Future<User> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await account.create(
        userId: ID.unique(),
        name: name,
        email: email,
        password: password,
      );
      return user;
    } finally {
      notifyListeners();
    }
  }

  Future<Session> createEmailSession({
    required String email,
    required String password,
  }) async {
    try {
      final session = await account.createEmailSession(
        email: email,
        password: password,
      );
      _currentUser = await account.get();
      _status = AuthStatus.authenticated;
      return session;
    } finally {
      notifyListeners();
    }
  }

  signOut() async {
    try {
      await account.deleteSession(sessionId: 'current');
      _status = AuthStatus.unauthenticated;
    } finally {
      notifyListeners();
    }
  }
}
