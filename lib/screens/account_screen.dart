import 'package:appwrite_test/appwrite/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? username;
  String? email;
  TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final AuthApi appwrite = context.read<AuthApi>();
    username = appwrite.userName;
    email = appwrite.email;
    appwrite.getUserPreferences().then((value) {
      if (value.data.isNotEmpty) {
        setState(() {
          bioController.text = value.data['bio'];
        });
      }
    });
  }

  updatePrefs() async {
    final AuthApi appwrite = context.read<AuthApi>();
    appwrite.updatePrefs(bio: bioController.text);
    const snackbar = SnackBar(content: Text('Bio updated!'));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(username ?? ''),
            const SizedBox(height: 8),
            Text(email ?? ''),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    TextField(
                      controller: bioController,
                      decoration: const InputDecoration(
                        labelText: 'Bio',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        updatePrefs();
                      },
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
