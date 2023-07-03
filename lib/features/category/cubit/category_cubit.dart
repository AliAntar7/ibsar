import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:ebsar2/core/constants/app_string.dart';
import 'package:ebsar2/core/models/book_model.dart';
import 'package:ebsar2/core/models/category_model.dart';
import 'package:ebsar2/main.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  static CategoryCubit get(context) => BlocProvider.of(context);


  Future<List<CategoryModel>> getCategories() async {
    categories = [];
    try {
      Uri url = Uri.parse('https://ebsar.website/api/categories');
      http.Response response = await http.get(url);
      var data = jsonDecode(response.body);
      data['data'].forEach((element) {
        categories.add(CategoryModel.fromJson(element));
      });
      print(
          '---------------------- The data of Categories is found successfully ----------------------');
    } catch (error) {
      print('The data of Categories is not found ----- the error ---> $error');
    }
    return categories;
  }


  AudioPlayer audioPlayer = AudioPlayer();
  bool isListening = false;
  SpeechToText speechToText = SpeechToText();
  String text = AppString.listen;
  FlutterTts tts = FlutterTts();
  List<CategoryModel> categories = [];
  List<String> categoriesNames = [];

  void readCategoriesName() async {
    isListening = false;
    print('the length of categories is ${categories.length}');
    emit(StartReadCategoriesName());
    categoriesNames = [];
    for (int i = 0; i < categories.length; i++) {
      categoriesNames.add(categories[i].name);
    }
    getImageForCategories();
    String categoriesNamesString = categoriesNames.join(' , ');
    print(categoriesNamesString);
    await tts.awaitSpeakCompletion(true);
    await tts.speak(
        'قائمة التصنيفات لدينا هي $categoriesNamesString, لإختيار تصنيف اضغط ضغطتان على الشاشة , و اذكر اسم التصنيف ')
        .whenComplete(() {

    });
    await tts.awaitSpeakCompletion(true);
    isListening = true;
    emit(EndReadCategoriesName());
  }

  List<String> categoriesImages = [];

  void getImageForCategories() async {
    categoriesImages = [];
    for (int i = 0; i < categoriesNames.length; i++) {
      for (int j = 0; j < categories.length; j++) {
        if (categoriesNames[i] == categories[j].name) {
          categoriesImages.add(categories[j].categoryImage);
        }
      }
    }
  }


  String categoryText = '';

  void listenToCategoryName() async {
    emit(StartListenToCategoryName());
    audioPlayer.stop();
    var available = await speechToText.initialize();
    if (available) {
      speechToText.listen(
        onResult: (result) {
          categoryText = result.confidence > 0.5 ? result.recognizedWords : ' ... جاري الاستماع ';
          print(categoryText);
          if(categoryText == 'تصنيف') {
            emit(const SearchingError(
              message: 'كلمة تصنيف لا تكفي',
            ));
          }else{
            if (result.finalResult) {
              print(categoryText);
              emit(EndListenToCategoryName());
              searchForBooksByCategoryName(categoryText);
            }
          }
        },
        listenMode: ListenMode.search,
        localeId: 'ar_EG',
      );
    }
  }

  List<String> bookNames = [];
  List<BookModel> books = GetBooks.books;

  void searchForBooksByCategoryName(String categoryText) async {
    try {
      emit(SearchingForBooksByCategoryNameLoading());
      bookNames = [];
      for (int i = 0; i < books.length; i++) {
        if (books[i].category.name.contains(categoryText)) {
          bookNames.add(books[i].name);
        }
      }
      if (bookNames.isEmpty) {
        emit(SearchingForBooksByCategoryNameError(
            message: 'لا يوجد تصنيف بهذا الاسم . ${categoryText}'));
      } else {
        emit(SearchingForBooksByCategoryNameDone(
            message: bookNames.join(' , ')));
      }
      getImageForBooks();
    } catch (e) {
      print(e);
    }
  }

  List<String> bookImages = [];
  void getImageForBooks() async {
    bookImages = [];
    for (int i = 0; i < bookNames.length; i++) {
      for (int j = 0; j < books.length; j++) {
        if (bookNames[i] == books[j].name) {
          bookImages.add(books[j].image.bookImage);
        }
      }
    }
    print(bookImages);
  }


  void readBookName() async {
    emit(StartReadBooksNames());
    String bookNamesString = bookNames.join(' , ');
    print('the book names is $bookNamesString');
    await tts.awaitSpeakCompletion(true);
    await tts.speak(
        ' قائمة الكتب المتاحه بتصنيف ${categoryText}, هي , $bookNamesString , لإختيار كتاب اضغط ضغطتان على الشاشة , و اذكر اسم الكتاب , ');
    await tts.awaitSpeakCompletion(true);
    isListening = true;
    emit(EndReadBooksNames());

  }

  void speechError({required String error}) async {
    await tts.speak(error);
    await tts.awaitSpeakCompletion(true);
  }

  BookModel? book;


}
