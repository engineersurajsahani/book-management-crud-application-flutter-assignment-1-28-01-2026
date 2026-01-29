import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  
  static const String baseUrl =
      "http://127.0.0.1:5001/api/books";

 
  static const Map<String, String> _headers = {
    "Content-Type": "application/json",
  };


  static Future<List<Book>> getBooks() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch books");
    }

    final decoded = jsonDecode(response.body);
    return (decoded['data'] as List)
        .map((item) => Book.fromJson(item))
        .toList();
  }

  
  static Future<void> addBook(Book book) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: _headers,
      body: jsonEncode(book.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to add book");
    }
  }

  
  static Future<void> updateBook(String id, Book book) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: _headers,
      body: jsonEncode(book.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update book");
    }
  }

  
  static Future<void> deleteBook(String id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/$id"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete book");
    }
  }
}
