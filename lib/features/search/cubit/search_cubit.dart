import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:ebsar2/core/constants/app_string.dart';
import 'package:ebsar2/core/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  static SearchCubit get(context) => BlocProvider.of(context);

  bool searchingIcon = false;

  List<BookModel> books = [];

  Future<List<BookModel>> getBooks() async {
    try {
      Uri url = Uri.parse('https://ebsar.website/api/books');
      http.Response response = await http.get(url);
      var data = jsonDecode(response.body);
      data['data'].forEach((element) {
        books.add(BookModel.fromJson(element));
      });
    } catch (error) {
      print('the $error');
    }
    return books;
  }

  AudioPlayer audioPlayer = AudioPlayer();
  bool isListening = false;

  void playWelcomeAudio() async {
    emit(StartWelcomeAudio());
    audioPlayer.play(AssetSource('voices/welcome.mp3'));
    audioPlayer.onPlayerComplete.listen((event) {
      isListening = true;
      emit(EndWelcomeAudio());
    });
  }

  void playWelcomeBackAudio() async {
    isListening = false;
    emit(StartWelcomeBackAudio());
    await audioPlayer.play(AssetSource('voices/welcome2.mp3'));
    audioPlayer.onPlayerComplete.listen((event) {
      isListening = true;
      emit(EndWelcomeBackAudio());
    });
  }

  SpeechToText speechToText = SpeechToText();
  String text = AppString.listen;

  void listen() async {
    emit(StartListening());
    var available = await speechToText.initialize();
    if (available) {
      speechToText.listen(
        onResult: (result) {
          text = result.recognizedWords;
          if (text.isEmpty) {
            print('قول كتاب ');
          } else {
            print(text);
            emit(EndListening());
            searchOnBooksList(text);
          }
        },
        listenMode: ListenMode.search,
        localeId: 'ar_EG',
      );
    }
  }


  BookModel? book;

  void searchOnBooksList(String text) async {
    try {
      book = null;
      emit(SearchingLoading());
      book = books.firstWhere((element) => element.name.contains(text));
      if (book!.name.contains(text)) {
        print('Audio book is found --->  ${book!.file.bookFile}');
        emit(SearchingDone());
        emit(TTSPlay());
        await tts.setLanguage('ar-EG');
        await tts.setSpeechRate(0.5);
        await tts.setPitch(1.0);
        await tts.setVolume(1.0);
        await tts.speak(
            'جاري تشغيل كتاب ${book!.name}, لإيقاف الكتاب اضغط على الشاشة مرتين , أو للعودة للقائمة الرئيسية اضغط على الشاشة مرة واحدة  ');
        await tts.awaitSpeakCompletion(true);
        emit(TTSDone());
        playAudioBook();
      } else {
        emit(SearchingError(message: 'لا يوجد كتاب بهذا الاسم . ${text}'));
      }
    } catch (e) {
      print(e);
      emit(SearchingError(message: 'لا يوجد كتاب بهذا الاسم . ${text}'));
    }
  }

  Future playAudioBook() async {
    emit(AudioPlaying());
    await audioPlayer.play(UrlSource(book!.file.bookFile));
    audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.stopped) {
        emit(AudioStopped());
      }
    });
    isListening = true;
    emit(AudioPlayed());
  }

  FlutterTts tts = FlutterTts();

  void stopListening() {
    //tts.stop();
    speechToText.stop();
    emit(StopListening());
  }

  void stopAudio() {
    //tts.stop();
    audioPlayer.stop();
    emit(AudioStopped());
  }

  void stopTTS() async{
    await tts.stop();
  }

  void speechError({required String error}) async {
    await tts.speak(error);
    await tts.awaitSpeakCompletion(true);
  }

  bool audioPlayingNow= true;
  void playAudio() {
    if (audioPlayingNow) {
      audioPlayer.pause();
      audioPlayingNow = false;
      emit(AudioPaused());
    } else {
      audioPlayer.resume();
      audioPlayingNow = true;
      emit(AudioResumed());
    }
  }
}






