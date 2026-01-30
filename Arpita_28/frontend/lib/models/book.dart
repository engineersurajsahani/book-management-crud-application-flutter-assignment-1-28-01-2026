class Book {
  String? id;
  String title;
  String author;
  String genre;
  int price;
  int publishedYear;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.price,
    required this.publishedYear,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json["_id"],
      title: json["title"],
      author: json["author"],
      genre: json["genre"],
      price: json["price"],
      publishedYear: json["publishedYear"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "author": author,
      "genre": genre,
      "price": price,
      "publishedYear": publishedYear,
    };
  }
}
