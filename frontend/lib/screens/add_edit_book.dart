import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book? book;
  AddEditBookScreen({this.book});

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController title;
  late TextEditingController author;
  late TextEditingController genre;
  late TextEditingController price;
  late TextEditingController year;

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.book?.title ?? "");
    author = TextEditingController(text: widget.book?.author ?? "");
    genre = TextEditingController(text: widget.book?.genre ?? "");
    price = TextEditingController(
        text: widget.book?.price.toString() ?? "");
    year = TextEditingController(
        text: widget.book?.publishedYear.toString() ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.book == null ? "Add Book" : "Edit Book"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: title,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextFormField(
                controller: author,
                decoration:
                    const InputDecoration(labelText: "Author"),
              ),
              TextFormField(
                controller: genre,
                decoration:
                    const InputDecoration(labelText: "Genre"),
              ),
              TextFormField(
                controller: price,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: "Price"),
              ),
              TextFormField(
                controller: year,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Published Year"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text("Save"),
                onPressed: () async {
                  if (int.tryParse(price.text) == null ||
                      int.tryParse(year.text) == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text("Price & Year must be numbers")),
                    );
                    return;
                  }

                  Book book = Book(
                    title: title.text,
                    author: author.text,
                    genre: genre.text,
                    price: int.parse(price.text),
                    publishedYear: int.parse(year.text),
                  );

                  if (widget.book == null) {
                    await ApiService.addBook(book);
                  } else {
                    await ApiService.updateBook(
                        widget.book!.id!, book);
                  }

                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
