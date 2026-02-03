import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;
  const EditBookScreen({super.key, required this.book});

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _title;
  late TextEditingController _author;
  late TextEditingController _genre;
  late TextEditingController _price;
  late TextEditingController _year;

  bool loading = false;

  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _title = TextEditingController(text: widget.book.title ?? "");
    _author = TextEditingController(text: widget.book.author ?? "");
    _genre = TextEditingController(text: widget.book.genre ?? "");
    _price =
        TextEditingController(text: widget.book.price?.toString() ?? "");
    _year =
        TextEditingController(text: widget.book.publishedYear?.toString() ?? "");

    _animController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  void updateBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    try {
      final updatedBook = Book(
        title: _title.text,
        author: _author.text,
        genre: _genre.text,
        price: double.tryParse(_price.text),
        publishedYear: int.tryParse(_year.text),
      );

      await ApiService.updateBook(widget.book.id!, updatedBook);

      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book updated successfully!")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed: $e")));
    }
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: (val) {
        if ((label == "Book Title" || label == "Author") &&
            (val == null || val.isEmpty)) {
          return "$label is required";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF333333)),
        filled: true,
        fillColor: const Color(0xFFF0FFDF),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              const BorderSide(color: Color(0xFFFFAAB8), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFA8DF8E)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Book"),
          backgroundColor: const Color(0xFFA8DF8E),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              shadowColor: Colors.black38,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField("Book Title", _title),
                      const SizedBox(height: 12),
                      buildTextField("Author", _author),
                      const SizedBox(height: 12),
                      buildTextField("Genre (Optional)", _genre),
                      const SizedBox(height: 12),
                      buildTextField("Price (Optional)", _price,
                          keyboard: TextInputType.number),
                      const SizedBox(height: 12),
                      buildTextField("Published Year (Optional)", _year,
                          keyboard: TextInputType.number),
                      const SizedBox(height: 20),
                      loading
                          ? const SpinKitFadingCircle(
                              color: Color(0xFFA8DF8E), size: 50)
                          : ElevatedButton(
                              onPressed: updateBook,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                backgroundColor: const Color(0xFFFFAAB8),
                                elevation: 6,
                              ),
                              child: const Text(
                                "Update Book",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
