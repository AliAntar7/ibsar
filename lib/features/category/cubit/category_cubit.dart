import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:ebsar2/core/constants/app_string.dart';
import 'package:ebsar2/core/models/book_model.dart';
import 'package:ebsar2/core/models/category_model.dart';
import 'package:flutter/material.dart';
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
    } catch (error) {
      print('the $error');
    }
    return categories;
  }

  String categoryText = '';
  List<String> bookNames = [];
  List<String> bookImages = [];

  AudioPlayer audioPlayer = AudioPlayer();
  bool isListening = false;
  SpeechToText speechToText = SpeechToText();
  String text = AppString.listen;
  BookModel? book;
  FlutterTts tts = FlutterTts();
  List<CategoryModel> categories = [];
  List<String> categoriesNames = [];

  void readCategoriesName () async {
    print('the length of categories is ${categories.length}');
    emit(StartReadCategoriesName());
    for (int i = 0; i < categories.length; i++) {
      categoriesNames.add(categories[i].name);
    }
    getImageForCategories();
    String categoriesNamesString = categoriesNames.join(' , ');
    print(categoriesNamesString);
    await tts.awaitSpeakCompletion(true);
    await tts.speak(
        'قائمة التصنيفات لدينا هي $categoriesNamesString, لإختيار تصنيف اضغط ضغطتان على الشاشة , و اذكر اسم التصنيف ').whenComplete(() {

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

}
