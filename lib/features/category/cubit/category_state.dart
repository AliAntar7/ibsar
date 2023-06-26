part of 'category_cubit.dart';

@immutable
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}
class StartReadCategoriesName extends CategoryState {}
class EndReadCategoriesName extends CategoryState {}
