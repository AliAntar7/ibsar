import 'package:equatable/equatable.dart';

class UserModel extends Equatable {

  int id = 0;
  String name = '';
  List<String> urFavorites = [];

  UserModel({
    required this.id,
    required this.name,
    required this.urFavorites,
  });


  @override
  List<Object?> get props => [
    id,
    name,
    urFavorites,
  ];
}
