class Book {
  String? id;
  String? title;
  String? author;
  String? genre;
  double? price;
  int? publishedYear;
  String? createdAt;

  Book({
    this.id,
    this.title,
    this.author,
    this.genre,
    this.price,
    this.publishedYear,
    this.createdAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      title: json['title'],
      author: json['author'],
      genre: json['genre'],
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      publishedYear: json['publishedYear'],
      createdAt: json['createdAt'],
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
