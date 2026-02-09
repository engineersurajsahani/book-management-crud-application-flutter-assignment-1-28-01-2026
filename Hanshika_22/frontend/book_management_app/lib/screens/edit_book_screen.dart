import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;
  const EditBookScreen({super.key, required this.book});

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _title;
  late TextEditingController _author;
  late TextEditingController _genre;
  late TextEditingController _price;
  late TextEditingController _year;

  bool loading = false;
  String? _errorMessage;

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
  }

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _genre.dispose();
    _price.dispose();
    _year.dispose();
    super.dispose();
  }

  void updateBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
      _errorMessage = null;
    });

    try {
      final updatedBook = Book(
        id: widget.book.id,
        title: _title.text.trim(),
        author: _author.text.trim(),
        genre: _genre.text.trim().isEmpty ? null : _genre.text.trim(),
        price: _price.text.isEmpty ? null : double.tryParse(_price.text),
        publishedYear: _year.text.isEmpty ? null : int.tryParse(_year.text),
      );

      await ApiService.updateBook(widget.book.id!, updatedBook);

      if (mounted) {
        setState(() => loading = false);
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
    String? hint,
    IconData? icon,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          required ? "$label *" : label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboard,
          validator: (val) {
            if (required && (val == null || val.trim().isEmpty)) {
              return "$label is required";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint ?? "Enter $label",
            prefixIcon: icon != null ? Icon(icon, size: 20) : null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bookTitle = widget.book.title?.isNotEmpty == true ? widget.book.title! : "?";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Book"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Large Book Cover Hero
                Center(
                  child: Hero(
                    tag: 'book-cover-${widget.book.id}',
                    child: Container(
                      width: 120,
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primary,
                            colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          bookTitle[0].toUpperCase(),
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                
                // Error Message
                if (_errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: colorScheme.onErrorContainer,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Form Fields
                _buildTextField(
                  "Book Title",
                  _title,
                  required: true,
                  hint: "Enter book title",
                  icon: Icons.title_rounded,
                ),
                const SizedBox(height: 24),
                
                _buildTextField(
                  "Author",
                  _author,
                  required: true,
                  hint: "Enter author name",
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 24),
                
                _buildTextField(
                  "Genre",
                  _genre,
                  hint: "e.g., Fiction, Science",
                  icon: Icons.category_outlined,
                ),
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        "Price",
                        _price,
                        keyboard: const TextInputType.numberWithOptions(decimal: true),
                        hint: "0.00",
                        icon: Icons.attach_money_rounded,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        "Year",
                        _year,
                        keyboard: TextInputType.number,
                        hint: "YYYY",
                        icon: Icons.calendar_today_rounded,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Submit Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: loading ? null : updateBook,
                    child: loading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: colorScheme.onPrimary,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Save Changes"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
