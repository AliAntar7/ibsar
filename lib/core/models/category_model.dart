import 'package:equatable/equatable.dart';
class CategoryModel extends Equatable{
  int id;
  String name;
  String categoryVoice;
  String categoryImage;

  CategoryModel({
    required this.id,
    required this.name,
    required this.categoryVoice,
    required this.categoryImage,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
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
    categoryImage,
  ];
}