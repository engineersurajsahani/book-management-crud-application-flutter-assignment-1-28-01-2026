import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import 'add_edit_book.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> books;

  @override
  void initState() {
    super.initState();
    books = ApiService.getBooks();
  }

  void refresh() {
    setState(() {
      books = ApiService.getBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Book Management"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Book>>(
        future: books,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No books added yet 📚",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final book = snapshot.data![index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Author: ${book.author}",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 4),
                      Text("Genre: ${book.genre}"),
                      Text("Price: ₹${book.price}"),
                      Text("Published: ${book.publishedYear}"),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            tooltip: "Edit Book",
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AddEditBookScreen(book: book),
                                ),
                              );
                              if (result == true) refresh();
                            },
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.delete, color: Colors.red),
                            tooltip: "Delete Book",
                            onPressed: () async {
                              await ApiService.deleteBook(book.id!);
                              refresh();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Book",
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEditBookScreen()),
          );
          if (result == true) refresh();
        },
      ),
    );
  }
}
