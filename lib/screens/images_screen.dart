import 'package:appwrite/models.dart';
import 'package:appwrite_test/appwrite/storage_api.dart';
import 'package:flutter/material.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({super.key});

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  final storage = StorageApi();
  List<File>? images = [];

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  loadImages() async {
    try {
      final value = await storage.getImages();
      setState(() {
        images = value.files;
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
        title: const Text('Images'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: images?.length ?? 0,
          itemBuilder: (context, index) {
            final image = images![index];
            return FutureBuilder(
              future: storage.getFileView(image.$id),
              builder: (context, snapshot) {
                return snapshot.hasData && snapshot.data != null
                    ? Image.memory(snapshot.data)
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              },
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 16);
          },
        ),
      ),
    );
  }
}
