// Imports Flutter's Material Design library
import 'package:flutter/material.dart';

// Imports the screen that will be shown as the home screen
import 'screens/book_list_screen.dart';

void main() {
  // Entry point of the Flutter application
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatelessWidget {
  // Constructor with optional key
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp is the base widget for a Flutter app using Material Design
    return MaterialApp(
      // Removes the debug banner shown in the top right corner
      debugShowCheckedModeBanner: false,

      // Title of the application (used by the OS)
      title: 'Book Manager',

      // Defines the global theme for the app
      theme: ThemeData(
        // Background color for all Scaffold widgets
        scaffoldBackgroundColor: const Color(0xFFF0FFDF),

        // Default font family for the app
        fontFamily: 'Roboto',

        // AppBar theme applied throughout the app
        appBarTheme: const AppBarTheme(
          // Background color of AppBar
          backgroundColor: Color(0xFFA8DF8E),

          // Color of AppBar text and icons
          foregroundColor: Color(0xFF2E2E2E),

          // Removes shadow below the AppBar
          elevation: 0,
        ),
      ),

      // First screen shown when the app launches
      home: const BookListScreen(),
    );
  }
}
