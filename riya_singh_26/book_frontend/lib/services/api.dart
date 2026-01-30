import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {

  // ✅ Backend running on 8080
  // Flutter Web → use localhost or 127.0.0.1
  static const String baseUrl =
      "http://127.0.0.1:8080/api/books";

  // =========================
  // GET ALL BOOKS
  // =========================
  Future<List<Book>> getBooks() async {
    final res = await http.get(Uri.parse(baseUrl));

    print("GET STATUS: ${res.statusCode}");

    if (res.statusCode != 200) {
      throw Exception("Failed to load books");
    }

    final List data = json.decode(res.body);
    return data.map((e) => Book.fromJson(e)).toList();
  }

  // =========================
  // ADD BOOK
  // =========================
  Future<void> addBook(Book book) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(book.toJson()),
    );

    print("ADD STATUS: ${res.statusCode}");
    print("ADD BODY: ${res.body}");

    if (res.statusCode != 201) {
      throw Exception("Add book failed");
    }
  }

  // =========================
  // UPDATE BOOK
  // =========================
  Future<void> updateBook(Book book) async {
    final res = await http.put(
      Uri.parse("$baseUrl/${book.id}"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(book.toJson()),
    );

    if (res.statusCode != 200) {
      throw Exception("Update failed");
    }
  }

  // =========================
  // DELETE BOOK
  // =========================
  Future<void> deleteBook(String id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$id"));

    if (res.statusCode != 200) {
      throw Exception("Delete failed");
    }
  }
}
