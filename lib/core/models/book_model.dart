import 'package:equatable/equatable.dart';

class BookModel extends Equatable {
  int id;
  String name;
  Category category;
  Author author;
  Image image;
  File file;
  Voice voice;

  BookModel({
    required this.id,
    required this.name,
    required this.category,
    required this.author,
    required this.image,
    required this.file,
    required this.voice,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
    id: json["id"],
    name: json["name"],
    category: Category.fromJson(json["category"]),
    author: Author.fromJson(json["auther"]),
    image: Image.fromJson(json["Image"]),
    file: File.fromJson(json["File"]),
    voice: Voice.fromJson(json["Voice"]),
  );


  @override
  List<Object?> get props => [
    id,
    name,
    category,
    author,
    image,
    file,
    voice,
  ];


}


class Author extends Equatable {
  String name;

  Author({
    required this.name,
  });

  factory Author.fromJson(Map<String, dynamic> json) =>
      Author(
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
  String categoryVoice;
  String categoryImage;

  Category({
    required this.id,
    required this.name,
    required this.categoryVoice,
    required this.categoryImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    categoryVoice: json["category_voice"],
    categoryImage: json["category_image"],
  );


  @override

  List<Object?> get props => [
    id,
    name,
    categoryVoice,
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

class Voice extends Equatable {
  String? bookVoice;

  Voice({
    required this.bookVoice,
  });

  factory Voice.fromJson(Map<String, dynamic> json) => Voice(
    bookVoice: json["book_voice"],
  );


  @override


  List<Object?> get props => [
    bookVoice,
  ];

}
