part of 'category_cubit.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}
class StartReadCategoriesName extends CategoryState {}
class EndReadCategoriesName extends CategoryState {}
class StartListenToCategoryName extends CategoryState {}
class StartReadBooksNames extends CategoryState {}
class EndReadBooksNames extends CategoryState {}
class EndListenToCategoryName extends CategoryState {}
class StartListening extends CategoryState {}
class EndListening extends CategoryState {}
class TTSPlay extends CategoryState {}
class TTSDone extends CategoryState {}
class SearchingLoading extends CategoryState {}
class SearchingDone extends CategoryState {}
class SearchingError extends CategoryState {
  final String message;
  const SearchingError({required this.message});
}
class SearchingForBooksByCategoryNameLoading extends CategoryState {}
class SearchingForBooksByCategoryNameDone extends CategoryState {
  final String message;
  const SearchingForBooksByCategoryNameDone({required this.message});
}
class SearchingForBooksByCategoryNameError extends CategoryState {
  final String message;
  const SearchingForBooksByCategoryNameError({required this.message});
}
