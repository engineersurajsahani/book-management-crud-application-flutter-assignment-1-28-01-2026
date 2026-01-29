import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  AddBookScreenState createState() => AddBookScreenState();
}

class AddBookScreenState extends State<AddBookScreen> {
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final genreController = TextEditingController();
  final priceController = TextEditingController();
  final publishedYearController = TextEditingController();

  void handleSubmit() async {
    Book book = Book(
      id: "",
      title: titleController.text,
      author: authorController.text,
      genre: genreController.text,
      price: priceController.text,
      publishedYear: publishedYearController.text,
    );
    await BookService.addBook(book);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Book')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: 'Author Name'),
            ),
            TextField(
              controller: genreController,
              decoration: const InputDecoration(labelText: 'Genre'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: publishedYearController,
              decoration: const InputDecoration(labelText: 'Published Year'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Add Book"),
              onPressed: () {
                handleSubmit();
              },
            ),
          ],
        ),
      ),
    );
  }
}
