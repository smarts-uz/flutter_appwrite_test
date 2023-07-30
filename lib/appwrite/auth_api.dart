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
    Account(client);
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
}
