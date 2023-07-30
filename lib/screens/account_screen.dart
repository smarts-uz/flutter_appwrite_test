import 'package:appwrite_test/appwrite/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  signOut() async {
    final AuthApi appwrite = context.read<AuthApi>();
    await appwrite.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        actions: [
          IconButton(
            onPressed: () {
              signOut();
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
    );
  }
}
