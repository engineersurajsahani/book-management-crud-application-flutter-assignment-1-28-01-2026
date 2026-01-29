import 'package:flutter/material.dart';
import 'screens/book_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Manager',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF0FFDF),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFA8DF8E),
          foregroundColor: Color(0xFF2E2E2E),
          elevation: 0,
        ),
      ),
      home: const BookListScreen(),
    );
  }
}
