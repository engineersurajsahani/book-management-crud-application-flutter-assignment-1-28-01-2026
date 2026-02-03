import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import '../widgets/book_card.dart';
import 'add_book_screen.dart';
import 'edit_book_screen.dart';
import 'delete_book_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Book> books = [];
  List<Book> filteredBooks = [];
  bool loading = true;
  String searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchBooks() async {
    try {
      final data = await ApiService.getBooks();
      setState(() {
        books = data;
        filteredBooks = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading books: $e")),
      );
    }
  }

  void _filterBooks(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredBooks = books;
      } else {
        filteredBooks = books.where((book) {
          final titleMatch = book.title?.toLowerCase().contains(query.toLowerCase()) ?? false;
          final authorMatch = book.author?.toLowerCase().contains(query.toLowerCase()) ?? false;
          final genreMatch = book.genre?.toLowerCase().contains(query.toLowerCase()) ?? false;
          return titleMatch || authorMatch || genreMatch;
        }).toList();
      }
    });
  }

  Widget _buildEmptyState() {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              searchQuery.isEmpty ? Icons.library_books_rounded : Icons.search_off_rounded,
              size: 56,
              color: colorScheme.primary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            searchQuery.isEmpty ? "Your Library is Empty" : "No Matches Found",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              searchQuery.isEmpty
                  ? "Tap the + button to add your first book to the collection."
                  : "Try checking for typos or using different keywords.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.secondary,
              ),
            ),
          ),
          if (searchQuery.isEmpty) ...[
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddBookScreen()),
                );
                if (result == true) fetchBooks();
              },
              icon: const Icon(Icons.add_rounded, size: 22),
              label: const Text("Add First Book"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBookList() {
    if (filteredBooks.isEmpty && searchQuery.isNotEmpty) {
      return _buildEmptyState();
    }
    return RefreshIndicator(
      onRefresh: fetchBooks,
      backgroundColor: Theme.of(context).cardColor,
      color: Theme.of(context).colorScheme.primary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: filteredBooks.length,
        itemBuilder: (context, index) {
          final book = filteredBooks[index];
          // Determine animation delay based on index for detailed staggered effect (if we had it)
          // For now just standard list
          return BookCard(
            book: book,
            onEdit: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditBookScreen(book: book),
                ),
              );
              if (result == true) fetchBooks();
            },
            onDelete: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DeleteBookScreen(book: book),
                ),
              );
              if (result == true) fetchBooks();
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Library"),
        actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: fetchBooks,
              tooltip: "Refresh",
            ),
            const SizedBox(width: 8),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search Bar Container
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterBooks,
                    decoration: InputDecoration(
                      hintText: "Search title, author, or genre...",
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                _searchController.clear();
                                _filterBooks('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainer,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Book Count
                if (filteredBooks.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.library_books_outlined,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${filteredBooks.length} book${filteredBooks.length != 1 ? 's' : ''}",
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Content
                Expanded(
                  child: books.isEmpty ? _buildEmptyState() : _buildBookList(),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddBookScreen()),
          );
          if (result == true) fetchBooks();
        },
        icon: const Icon(Icons.add_rounded, size: 24),
        label: const Text(
          "New Book",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
