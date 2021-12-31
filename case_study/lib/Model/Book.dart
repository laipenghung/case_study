import 'package:flutter/foundation.dart';

class Book {
  final int? id, page;
  final String? name, description, picture;

  Book({this.id, this.name, this.page, this.description, this.picture});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        id: json['book_id'],
        name: json['book_name'],
        page: json['book_pages'],
        description: json['book_desc'],
        picture: json['book_picture']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'page': page,
      'description': description,
      'picture': picture,
    };
  }

  Map<String, dynamic> toMapID() {
    return {
      'bookID': id,
    };
  }
}
