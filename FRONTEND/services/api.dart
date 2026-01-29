import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static const String baseUrl =
      "http://127.0.0.1:8080/api/books";

  Future<List<Book>> getBooks() async {
    final res = await http.get(Uri.parse(baseUrl));
    final List data = json.decode(res.body);
    return data.map((e) => Book.fromJson(e)).toList();
  }

  Future<void> addBook(Book book) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(book.toJson()),
    );
  }

  Future<void> updateBook(Book book) async {
    await http.put(
      Uri.parse("$baseUrl/${book.id}"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(book.toJson()),
    );
  }

  Future<void> deleteBook(String id) async {
    await http.delete(Uri.parse("$baseUrl/$id"));
  }
}
