// ignore_for_file: use_build_context_synchronously

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_test/appwrite/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  signup() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [CircularProgressIndicator()],
          ),
        );
      },
    );
    try {
      final AuthApi appwrite = context.read<AuthApi>();
      await appwrite.createUser(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
      const snackbar = SnackBar(content: Text('Account created!'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } on AppwriteException catch (e) {
      Navigator.of(context);
      showAlert(title: 'Failed!', text: e.message.toString());
    }
  }

  showAlert({required String title, required String text}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  signup();
                },
                icon: const Icon(Icons.app_registration_rounded),
                label: const Text('Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
