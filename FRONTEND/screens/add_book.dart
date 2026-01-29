import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final title = TextEditingController();
  final author = TextEditingController();
  final genre = TextEditingController();
  final price = TextEditingController();
  final year = TextEditingController();

  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Book")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: title, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: author, decoration: const InputDecoration(labelText: "Author")),
            TextField(controller: genre, decoration: const InputDecoration(labelText: "Genre")),
            TextField(controller: price, decoration: const InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
            TextField(controller: year, decoration: const InputDecoration(labelText: "Published Year"), keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () async {
                await api.addBook(Book(
                  title: title.text,
                  author: author.text,
                  genre: genre.text,
                  price: int.parse(price.text),
                  publishedYear: int.parse(year.text),
                ));
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
