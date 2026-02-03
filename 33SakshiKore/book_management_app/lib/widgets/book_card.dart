// Imports Flutter Material UI components
import 'package:flutter/material.dart';

// Imports the Book model
import '../models/book.dart';

// A reusable UI component to display a single book item
class BookCard extends StatelessWidget {
  // Book data to be displayed
  final Book book;

  // Callback function when edit icon is pressed
  final VoidCallback onEdit;

  // Callback function when the card is dismissed (delete)
  final VoidCallback onDelete;

  // Constructor with required parameters
  const BookCard({
    super.key,
    required this.book,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // ---------- NULL-SAFE VALUE HANDLING ----------

    // If title is null or empty, default to "Untitled"
    final String title = (book.title != null && book.title!.trim().isNotEmpty)
        ? book.title!
        : "Untitled";

    // If author is null or empty, default to "Unknown"
    final String author =
        (book.author != null && book.author!.trim().isNotEmpty)
            ? book.author!
            : "Unknown";

    // Genre can be empty, so default to empty string
    final String genre = book.genre ?? "";

    // ---------- DISMISSIBLE WIDGET FOR SWIPE DELETE ----------
    return Dismissible(
      // Unique key required for identifying each item
      key: ValueKey(book.id ?? UniqueKey().toString()),

      // Allows swipe from right to left only
      direction: DismissDirection.endToStart,

      // Calls delete function when dismissed
      onDismissed: (_) => onDelete(),

      // Background shown while swiping
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.redAccent,
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      // ---------- BOOK CARD UI ----------
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

        // Rounded corners for card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        child: Container(
          padding: const EdgeInsets.all(16),

          // Gradient background for aesthetic UI
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFA8DF8E),
                Color(0xFFF0FFDF),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),

          // Horizontal layout for avatar + text + edit button
          child: Row(
            children: [
              // ---------- BOOK AVATAR ----------
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFFFAAB8),

                // Displays first letter of book title
                child: Text(
                  title[0].toUpperCase(), // Safe because title is never empty
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // ---------- BOOK DETAILS ----------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book title
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Author name
                    Text(
                      "by $author",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),

                    // Show genre only if it exists
                    if (genre.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        "Genre: $genre",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ---------- EDIT BUTTON ----------
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
