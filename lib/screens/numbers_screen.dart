import 'package:appwrite/models.dart';
import 'package:appwrite_test/appwrite/database_api.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NumbersScreen extends StatefulWidget {
  const NumbersScreen({super.key});

  @override
  State<NumbersScreen> createState() => _NumbersScreenState();
}

class _NumbersScreenState extends State<NumbersScreen> {
  final database = DatatbaseApi();
  static const _pageSize = 20;

  final PagingController<int, Document> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await database.getNumbers(pageKey, _pageSize);
      final isLastPage = newItems.documents.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.documents);
      } else {
        final nextPageKey = pageKey + newItems.documents.length;
        _pagingController.appendPage(newItems.documents, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Numbers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: RefreshIndicator(
          onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
          ),
          child: PagedListView<int, Document>.separated(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Document>(
              itemBuilder: (context, item, index) {
                return ListTile(
                  leading: Text(item.data['number'].toString()),
                  title: Text(item.data['text']),
                  tileColor: Colors.grey.shade100,
                );
              },
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          ),
        ),
      ),
    );
  }
}
