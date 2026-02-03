import 'package:flutter/material.dart';
import '../models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BookCard({
    super.key,
    required this.book,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String title = (book.title != null && book.title!.trim().isNotEmpty)
        ? book.title!
        : "Untitled";

    final String author =
        (book.author != null && book.author!.trim().isNotEmpty)
            ? book.author!
            : "Unknown";

    final String genre = book.genre ?? "";
    final double? price = book.price;
    final int? year = book.publishedYear;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Cover (Gradient Stub)
                Hero(
                  tag: 'book-cover-${book.id}',
                  child: Container(
                    width: 70,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary,
                          colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        title.isNotEmpty ? title[0].toUpperCase() : "?",
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Action Menu
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          // Edit/Delete as small discreet buttons or a popup menu?
                          // Let's keep them as small icons but styled better later.
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Tags (Genre, Year)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (genre.isNotEmpty)
                            _buildTag(context, genre, Colors.purple),
                          if (year != null)
                            _buildTag(context, year.toString(), Colors.blue),
                          if (price != null)
                             _buildTag(context, "\$${price.toStringAsFixed(2)}", Colors.green, isPrice: true),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Vertical Actions
                Column(
                  children: [
                     _buildIconButton(
                      context,
                      Icons.edit_rounded,
                      colorScheme.primary,
                      onEdit,
                     ),
                     const SizedBox(height: 8),
                     _buildIconButton(
                      context,
                      Icons.delete_outline_rounded,
                      colorScheme.error,
                      onDelete,
                     ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String text, Color baseColor, {bool isPrice = false}) {
    final theme = Theme.of(context);
    // Use the baseColor but adapt to theme brightness? 
    // For simplicity, let's use the theme's colors or washed out versions of baseColor
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: baseColor.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: baseColor.withOpacity(0.9),
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: color,
          ),
        ),
      ),
    );
  }
}
