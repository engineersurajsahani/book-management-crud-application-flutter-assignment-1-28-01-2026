import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api.dart';
import 'add_book.dart';
import 'edit_book.dart';

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  final ApiService api = ApiService();
  List<Book> books = [];
  bool loading = true;

  void loadBooks() async {
    books = await api.getBooks();
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Books")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (_, i) {
                final b = books[i];
                return ListTile(
                  title: Text(b.title),
                  subtitle: Text(b.author),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await api.deleteBook(b.id!);
                      loadBooks();
                    },
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditBook(book: b),
                      ),
                    );
                    loadBooks();
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddBook()),
          );
          loadBooks();
        },
      ),
    );
  }
}
