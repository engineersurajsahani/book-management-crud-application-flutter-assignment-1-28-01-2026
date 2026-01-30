import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api.dart';

class EditBook extends StatefulWidget {
  final Book book;
  const EditBook({super.key, required this.book});

  @override
  State<EditBook> createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  late TextEditingController title;
  late TextEditingController author;
  late TextEditingController genre;
  late TextEditingController price;
  late TextEditingController year;

  final ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.book.title);
    author = TextEditingController(text: widget.book.author);
    genre = TextEditingController(text: widget.book.genre);
    price = TextEditingController(text: widget.book.price.toString());
    year = TextEditingController(text: widget.book.publishedYear.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Book")),
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
              child: const Text("Update"),
              onPressed: () async {
                await api.updateBook(Book(
                  id: widget.book.id,
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
