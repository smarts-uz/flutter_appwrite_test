import 'package:appwrite_test/appwrite/auth_api.dart';
import 'package:appwrite_test/screens/login_screen.dart';
import 'package:appwrite_test/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthApi(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<AuthApi>().status;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Appwrite Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: status == AuthStatus.uninitialized
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : status == AuthStatus.authenticated
              ? const TabsScreen()
              : const LoginScreen(),
    );
  }
}
