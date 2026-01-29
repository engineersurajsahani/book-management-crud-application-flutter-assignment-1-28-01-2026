import 'package:flutter/material.dart';
import './screens/book_list.dart';
import './screens/add_book.dart';
import './screens/edit_book.dart';
import './screens/view_book.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book CRUD App',
      initialRoute: '/',
      routes: {
        '/': (context) => const BookListScreen(),
        '/add_book': (context) => const AddBookScreen(),
        '/edit_book': (context) => const EditBookScreen(),
        '/view_book': (context) => const ViewBookScreen(),
      },
    );
  }
}