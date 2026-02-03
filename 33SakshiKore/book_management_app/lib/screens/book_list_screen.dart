import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/api_service.dart';
import '../widgets/book_card.dart';
import 'add_book_screen.dart';
import 'edit_book_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Book> books = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final data = await ApiService.getBooks();
      setState(() {
        books = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading books: $e")),
      );
    }
  }

  Future<void> deleteBook(String id) async {
    try {
      await ApiService.deleteBook(id);
      setState(() {
        books.removeWhere((b) => b.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book deleted")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Delete failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Management"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : books.isEmpty
              ? const Center(child: Text("No books found"))
              : RefreshIndicator(
                  onRefresh: fetchBooks,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return BookCard(
                        book: book,
                        onEdit: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditBookScreen(book: book),
                            ),
                          );
                          if (result == true) fetchBooks();
                        },
                        onDelete: () => deleteBook(book.id!),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddBookScreen()),
          );
          if (result == true) fetchBooks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
