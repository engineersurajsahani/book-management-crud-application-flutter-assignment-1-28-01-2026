import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class EditBookScreen extends StatefulWidget {
  const EditBookScreen({super.key});

  @override
  EditBookScreenState createState() => EditBookScreenState();
}

class EditBookScreenState extends State<EditBookScreen> {
  final idController = TextEditingController();
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final genreController = TextEditingController();
  final priceController = TextEditingController();
  final publishedYearController = TextEditingController();

  void handleSubmit() async {
    Book book = Book(
      id: idController.text,
      title: titleController.text,
      author: authorController.text,
      genre: genreController.text,
      price: priceController.text,
      publishedYear: publishedYearController.text,
    );
    await BookService.updateBook(book);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Book book = ModalRoute.of(context)!.settings.arguments as Book;
    idController.text = book.id;
    titleController.text = book.title;
    authorController.text = book.author;
    genreController.text = book.genre;
    priceController.text = book.price;
    publishedYearController.text = book.publishedYear;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Book')),
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
              child: const Text("Update Book"),
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
