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

            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: "Title"),
            ),

            TextField(
              controller: author,
              decoration: const InputDecoration(labelText: "Author"),
            ),

            TextField(
              controller: genre,
              decoration: const InputDecoration(labelText: "Genre"),
            ),

            TextField(
              controller: price,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price"),
            ),

            TextField(
              controller: year,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Published Year"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text("Save"),

              onPressed: () async {

                // ✅ Required field check
                if (title.text.isEmpty || author.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Title and Author are required"),
                    ),
                  );
                  return;
                }

                try {

                  final book = Book(
                    title: title.text,
                    author: author.text,
                    genre: genre.text,
                    price: int.tryParse(price.text) ?? 0,
                    publishedYear: int.tryParse(year.text) ?? 0,
                  );

                  await api.addBook(book);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Book Added Successfully"),
                    ),
                  );

                  Navigator.pop(context, true);

                } catch (e) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: $e"),
                    ),
                  );

                }

              },
            )

          ],
        ),
      ),
    );
  }
}
