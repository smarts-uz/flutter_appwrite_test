import 'package:appwrite/models.dart';
import 'package:appwrite_test/appwrite/auth_api.dart';
import 'package:appwrite_test/appwrite/database_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController messageController = TextEditingController();
  final database = DatatbaseApi();
  List<Document>? messages = [];
  AuthStatus authStatus = AuthStatus.uninitialized;

  @override
  void initState() {
    super.initState();
    final AuthApi appwrite = context.read<AuthApi>();
    authStatus = appwrite.status;
    loadMessages();
  }

  loadMessages() async {
    try {
      final value = await database.getMessages();
      setState(() {
        messages = value.documents;
      });
    } catch (e) {
      showAlert(title: 'Loading Failed!', text: e.toString());
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
        title: const Text('Messages'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            authStatus == AuthStatus.authenticated
                ? Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: const InputDecoration(
                            labelText: 'Type a message',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.send_rounded),
                      ),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: messages?.length ?? 0,
                itemBuilder: (context, index) {
                  final message = messages![index];
                  return Card(
                    child: ListTile(
                      title: Text(message.data['text']),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete_rounded),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
