import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _author = TextEditingController();
  final _genre = TextEditingController();
  final _price = TextEditingController();
  final _year = TextEditingController();

  bool loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _genre.dispose();
    _price.dispose();
    _year.dispose();
    super.dispose();
  }

  void saveBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
      _errorMessage = null;
    });

    try {
      final book = Book(
        title: _title.text.trim(),
        author: _author.text.trim(),
        genre: _genre.text.trim().isEmpty ? null : _genre.text.trim(),
        price: _price.text.isEmpty ? null : double.tryParse(_price.text),
        publishedYear: _year.text.isEmpty ? null : int.tryParse(_year.text),
      );

      await ApiService.addBook(book);

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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Book"),
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
                // Minimal Book Icon Animation or Hero Placeholder
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.auto_stories_rounded,
                      size: 40,
                      color: colorScheme.primary,
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
                    onPressed: loading ? null : saveBook,
                    child: loading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: colorScheme.onPrimary,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Add Book"),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Tips
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline_rounded,
                        color: colorScheme.secondary,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Tip: Adding genre, price, and year helps organize your library better!",
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
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
