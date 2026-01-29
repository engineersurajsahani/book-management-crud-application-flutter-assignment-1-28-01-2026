import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book? book;
  const AddEditBookScreen({super.key, this.book});

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
    price =
        TextEditingController(text: widget.book?.price.toString() ?? "");
    year =
        TextEditingController(text: widget.book?.publishedYear.toString() ?? "");
  }

  /// 🔹 Reusable styled text field
  Widget buildField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.book == null ? "Add Book" : "Edit Book"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  buildField(controller: title, label: "Book Title"),
                  buildField(controller: author, label: "Author Name"),
                  buildField(controller: genre, label: "Genre / Category"),
                  buildField(
                    controller: price,
                    label: "Price",
                    keyboardType: TextInputType.number,
                  ),
                  buildField(
                    controller: year,
                    label: "Published Year",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text("Save Book"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (int.tryParse(price.text) == null ||
                            int.tryParse(year.text) == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Price & Year must be numbers"),
                            ),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
