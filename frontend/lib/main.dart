import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BookManagementScreen(),
    );
  }
}

class BookManagementScreen extends StatefulWidget {
  const BookManagementScreen({super.key});

  @override
  _BookManagementScreenState createState() => _BookManagementScreenState();
}

class _BookManagementScreenState extends State<BookManagementScreen> {
  late Future<List<dynamic>> books;

  @override
  void initState() {
    super.initState();
    books = fetchBooks();
  }

  Future<List<dynamic>> fetchBooks() async {
    final response = await http.get(Uri.parse("http://localhost:3000/fetch-books"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch books");
    }
  }

  Future<void> deleteBook(String id) async {
    final response = await http.delete(Uri.parse("http://localhost:3000/delete-book/$id"));
    if (response.statusCode == 200) {
      setState(() {
        books = fetchBooks();
      });
    } else {
      throw Exception("Failed to delete book");
    }
  }

  Future<void> updateBook(String id, Map<String, dynamic> bookData) async {
    final response = await http.put(
      Uri.parse("http://localhost:3000/update-book/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(bookData),
    );
    if (response.statusCode == 200) {
      setState(() {
        books = fetchBooks();
      });
    } else {
      throw Exception("Failed to update book");
    }
  }

  void showEditDialog(BuildContext context, Map<String, dynamic> book) {
    final TextEditingController titleController = TextEditingController(text: book["title"]);
    final TextEditingController authorController = TextEditingController(text: book["author"]);
    final TextEditingController priceController = TextEditingController(text: book["price"].toString());
    final TextEditingController genreController = TextEditingController(text: book["genre"]);
    final TextEditingController yearController = TextEditingController(text: book["publishedYear"].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Book"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
                TextField(controller: authorController, decoration: InputDecoration(labelText: "Author")),
                TextField(controller: priceController, decoration: InputDecoration(labelText: "Price")),
                TextField(controller: genreController, decoration: InputDecoration(labelText: "Genre")),
                TextField(controller: yearController, decoration: InputDecoration(labelText: "Published Year")),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final updatedBook = {
                  "title": titleController.text,
                  "author": authorController.text,
                  "price": int.parse(priceController.text),
                  "genre": genreController.text,
                  "publishedYear": int.parse(yearController.text),
                };
                updateBook(book["id"].toString(), updatedBook);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void showAddBookDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController authorController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController genreController = TextEditingController();
    final TextEditingController yearController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Book"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
                TextField(controller: authorController, decoration: InputDecoration(labelText: "Author")),
                TextField(controller: priceController, decoration: InputDecoration(labelText: "Price")),
                TextField(controller: genreController, decoration: InputDecoration(labelText: "Genre")),
                TextField(controller: yearController, decoration: InputDecoration(labelText: "Published Year")),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final newBook = {
                  "title": titleController.text,
                  "author": authorController.text,
                  "price": int.parse(priceController.text),
                  "genre": genreController.text,
                  "publishedYear": int.parse(yearController.text),
                };
                addBook(newBook);
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<void> addBook(Map<String, dynamic> bookData) async {
    final response = await http.post(
      Uri.parse("http://localhost:3000/add-book"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(bookData),
    );
    if (response.statusCode == 200) {
      setState(() {
        books = fetchBooks();
      });
    } else {
      throw Exception("Failed to add book");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Management"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showAddBookDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(book["title"]),
                    subtitle: Text("Author: ${book["author"]}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => showEditDialog(context, book),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteBook(book["id"].toString()),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}