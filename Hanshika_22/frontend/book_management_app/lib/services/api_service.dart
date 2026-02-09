import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static const String baseUrl = "http://localhost:3001/api/books";

  static Future<List<Book>> getBooks() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Book.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load books");
    }
  }

  static Future<Book> addBook(Book book) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(book.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Book.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to add book");
    }
  }

  static Future<void> deleteBook(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete book");
    }
  }

  static Future<Book> updateBook(String id, Book book) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(book.toJson()),
    );

    if (response.statusCode == 200) {
      return Book.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to update book");
    }
  }
}
