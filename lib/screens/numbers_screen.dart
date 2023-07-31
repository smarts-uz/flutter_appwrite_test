import 'package:appwrite/models.dart';
import 'package:appwrite_test/appwrite/database_api.dart';
import 'package:flutter/material.dart';

class NumbersScreen extends StatefulWidget {
  const NumbersScreen({super.key});

  @override
  State<NumbersScreen> createState() => _NumbersScreenState();
}

class _NumbersScreenState extends State<NumbersScreen> {
  final database = DatatbaseApi();
  List<Document>? numbers = [];

  @override
  void initState() {
    super.initState();
    loadNumbers();
  }

  loadNumbers() async {
    try {
      final value = await database.getNumbers();
      setState(() {
        numbers = value.documents;
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
        title: const Text('Numbers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: numbers?.length ?? 0,
                itemBuilder: (context, index) {
                  final message = numbers![index];
                  return Card(
                    child: ListTile(
                      leading: Text(message.data['number'].toString()),
                      title: Text(message.data['text']),
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
