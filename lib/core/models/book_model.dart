import 'package:equatable/equatable.dart';

class BookModel extends Equatable {
  int id;
  String name;
  Category category;
  SearchOfWords searchOfWords;
  Publisher publisher;
  Image image;
  File file;

  BookModel({
    required this.id,
    required this.name,
    required this.category,
    required this.searchOfWords,
    required this.image,
    required this.file,
    required this.publisher,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
    id: json["id"],
    name: json["name"],
    category: Category.fromJson(json["category"]),
    searchOfWords: SearchOfWords.fromJson(json["search_words"]),
    publisher: Publisher.fromJson(json["publisher"]),
    image: Image.fromJson(json["Image"]),
    file: File.fromJson(json["File"]),
  );


  @override
  List<Object?> get props => [
    id,
    name,
    category,
    searchOfWords,
    image,
    file,
    publisher,
  ];


}

class Publisher extends Equatable {
  String name;

  Publisher({
    required this.name,
  });

  factory Publisher.fromJson(Map<String, dynamic> json) =>
      Publisher(
        name: json["name"],
      );

  @override
  List<Object?> get props => [
    name,
  ];
}

class SearchOfWords extends Equatable {
  String name;

  SearchOfWords({
    required this.name,
  });

  factory SearchOfWords.fromJson(Map<String, dynamic> json) =>
      SearchOfWords(
        name: json["name"],
      );

  @override

  List<Object?> get props => [
    name,
  ];
}

class Category extends Equatable {
  int id;
  String name;
  String categoryImage;

  Category({
    required this.id,
    required this.name,
    required this.categoryImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    categoryImage: json["category_image"],
  );


  @override

  List<Object?> get props => [
    id,
    name,
  ];
}

class Image extends Equatable {
  String bookImage;

  Image({
    required this.bookImage,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    bookImage: json["book_image"],
  );


  @override

  List<Object?> get props => [
    bookImage,
  ];
}

class File extends Equatable {
  String bookFile;

  File({
    required this.bookFile,
  });

  factory File.fromJson(Map<String, dynamic> json) => File(
    bookFile: json["book_file"],
  );


  @override

  List<Object?> get props => [
    bookFile,
  ];

}

