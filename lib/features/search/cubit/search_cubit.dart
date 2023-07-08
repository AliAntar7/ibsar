import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:ebsar2/core/constants/app_string.dart';
import 'package:ebsar2/core/di/di.dart';
import 'package:ebsar2/core/models/book_model.dart';
import 'package:ebsar2/core/utils/pref.dart';
import 'package:ebsar2/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  static SearchCubit get(context) => BlocProvider.of(context);

  bool searchingIcon = false;

  List<BookModel> books = GetBooks.books;

  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer audioPlayer2 = AudioPlayer();
  bool isListening = false;

  // late int userId = int.parse(sl<MySharedPref>().getString(key: MySharedKeys.userID));
  // late String userName = sl<MySharedPref>().getString(key: MySharedKeys.userName);

  // this function to play the welcome audio
  void playWelcomeAudio() async {
    myFavoriteBooks = [];
    print(myFavoriteBooks);
    emit(StartWelcomeAudio());
    audioPlayer.play(AssetSource('voices/welcome3.mp3'));
    audioPlayer.onPlayerComplete.listen((event) {
      isListening = true;
      emit(EndWelcomeAudio());
    });
  }

  // this function to play the welcome back audio
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

  // this function to start listening to the user voice and convert it to text and search on the books list for the book name
  void listen() async {
    emit(StartListening());
    searchingIcon = true;
    var available = await speechToText.initialize();
    if (available) {
      speechToText.listen(
        onResult: (result) {
          text = result.confidence > 0.5
              ? result.recognizedWords
              : ' ... جاري الاستماع ';
          print(text);
          if (text == 'كتاب') {
            emit(const SearchingError1(
              message: 'كلمة كتاب لا تكفي للبحث',
            ));
          } else {
            if (result.finalResult) {
              emit(EndListening());
              searchOnBooksList(text);
            }
          }
        },
        listenMode: ListenMode.search,
        localeId: 'ar_EG',
        listenFor: const Duration(seconds: 5),
      );
    }
  }

  BookModel? book;

  void searchOnBooksList(String text) async {
    try {
      book = null;
      emit(SearchingLoading());
      book = books.firstWhere((element) => element.searchOfWords.name.contains(text));
      if (book!.searchOfWords.name.contains(text)) {
        print('Audio book is found --->  ${book!.file.bookFile}');
        emit(SearchingDone1());
        emit(TTSPlay1());
        await tts.setLanguage('ar-EG');
        await tts.setSpeechRate(0.5);
        await tts.setPitch(1.0);
        await tts.setVolume(1.0);
        await tts.speak('جاري تشغيل ${book!.name}');
        await tts.speak(
            ' لإيقاف الكتاب أو تشغيله اضغط على الشاشة مرتين , أو للعودة للقائمة الرئيسية اضغط على الشاشة مرة واحدة ');
        await tts.speak(
            'و لإضافة الكتاب إلى المفضلة أو إزالته , أسحب الشاشة للأعلى');
        await tts.awaitSpeakCompletion(true);
        emit(TTSDone1());
        if (state is TTSDone1) {
          playAudioBook();
          // if (userStoppedInSecond == 0) {
          //   playAudioBook();
          // }else {
          //   goToPosition();
          //   emit(PlayPositionUserStopped());
          // }
        } else {
          emit(SearchingError1(message: 'لا يوجد كتاب بهذا الاسم . ${text}'));
        }
      }
    } catch (e) {
      print(e);
      emit(SearchingError1(message: 'لا يوجد كتاب بهذا الاسم . ${text}'));
    }
  }

  AudioPlayer audioBookPlayer = AudioPlayer();
  Duration? position;
  Duration? duration;
  int userStoppedInSecond = 0;
  Future playAudioBook() async {
    emit(AudioPlaying());
    await audioBookPlayer.play(UrlSource(book!.file.bookFile));
    audioBookPlayer.getCurrentPosition();
    audioBookPlayer.getDuration();
    audioBookPlayer.onPositionChanged.listen((event) {
      position = event;
    });
    audioBookPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.stopped) {
        userStoppedInSecond = position!.inSeconds;
        print('user stopped in second $userStoppedInSecond');
        emit(AudioStopped());
      }
    });
    isListening = true;
    emit(AudioPlayed());
  }

  void goToPosition() async {
    // await tts.setLanguage('ar-EG');
    // await tts.setSpeechRate(0.5);
    // await tts.setPitch(1.0);
    // await tts.setVolume(1.0);
    await tts.speak('جاري الانتقال للموضع الذي توقفت عنده');
    await tts.awaitSpeakCompletion(true);
    await audioBookPlayer.play(UrlSource(book!.file.bookFile), position: Duration(seconds: userStoppedInSecond));
    audioBookPlayer.onPositionChanged.listen((event) {
      position = event;
    });
    audioBookPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.stopped) {
        userStoppedInSecond = position!.inSeconds;
        print('user stopped in second $userStoppedInSecond');
        emit(AudioStopped());
      }
    });
    isListening = true;
    emit(AudioPlayed());
  }

  bool audioBookPlayingNow = true;

  void playAudio() {
    if (audioBookPlayingNow) {
      audioBookPlayer.pause();
      audioBookPlayingNow = false;
      emit(AudioPaused());
    } else {
      audioBookPlayer.resume();
      audioBookPlayingNow = true;
      emit(AudioResumed());
    }
  }

  FlutterTts tts = FlutterTts();

  void stopListening() {
    //tts.stop();
    speechToText.stop();
    emit(StopListening());
  }

  void stopAudio() {
    //tts.stop();
    audioBookPlayer.stop();
    emit(AudioStopped());
  }

  void stopTTS() async {
    await tts.stop();
  }

  void speechError({required String error}) async {
    await tts.speak(error);
    //await tts.awaitSpeakCompletion(true);
  }

/////////////////////////////////////////////////////////////////////////////////
  List<String> myFavoriteBooks =
      sl<MySharedPref>().getStringList(key: MySharedKeys.favourites);

  void makeItFavorite() async {
    emit(AddingToFavorites());
    if (myFavoriteBooks.contains(book!.name)) {
      audioPlayer.pause();
      await tts.setLanguage('ar-EG');
      await tts.setSpeechRate(0.5);
      await tts.setPitch(1.0);
      await tts.setVolume(1.0);
      await tts.speak('تم إزالة الكتاب من المفضلة ');
      await tts.awaitSpeakCompletion(true);
      sl<MySharedPref>().deleteStringFromList(
          key: MySharedKeys.favourites, value: book!.name);
      myFavoriteBooks.remove(book!.name);
      audioPlayer.resume();
      emit(RemoveFromFavorite());
    } else {
      audioPlayer.pause();
      await tts.setLanguage('ar-EG');
      await tts.setSpeechRate(0.45);
      await tts.setPitch(1.0);
      await tts.setVolume(1.0);
      await tts.speak('تم إضافة الكتاب إلى المفضلة ');
      await tts.awaitSpeakCompletion(true);
      sl<MySharedPref>()
          .addStringToList(key: MySharedKeys.favourites, value: book!.name);
      myFavoriteBooks.add(book!.name);
      audioPlayer.resume();
      emit(AddedToFavorites());
    }
    print('now your favorite books are : ${myFavoriteBooks.toString()}');
  }

  bool isFavoritesEmpty() {
    return myFavoriteBooks.isEmpty ? true : false;
  }

  void noBookFavorite() async {
    await tts.setLanguage('ar-EG');
    await tts.setSpeechRate(0.5);
    await tts.setPitch(1.0);
    await tts.setVolume(1.0);
    await tts.speak('لا يوجد كتب مفضلة حتى الآن ');
    await tts.awaitSpeakCompletion(true);
  }

  void readTheFavorites() async {
    emit(StartReadTheFavorites());
    if (myFavoriteBooks.isEmpty) {
      noBookFavorite();
    } else {
      await tts.speak('الكتب المفضلة لديك هي');
      for (int i = 0; i < myFavoriteBooks.length; i++) {
        await tts.setLanguage('ar-EG');
        await tts.setSpeechRate(0.5);
        await tts.setPitch(1.0);
        await tts.setVolume(1.0);
        await tts.speak(myFavoriteBooks[i]);
        await tts.awaitSpeakCompletion(true);
      }
      await tts.speak('لاختيار الكتاب اضغط على الشاشة مرتين و اذكر اسم الكتاب');
      isListening = true;
    }
    emit(EndReadTheFavorites());
  }

// void createUser() async {
// //   emit(StartCreating());
// // if (userName.isEmpty) {
// //   Random random = Random();
// //   int id = random.nextInt(1000);
// //   sl<MySharedPref>()
// //       .putString(key: MySharedKeys.userID, value: id.toString());
// //   isListening = false;
// //   // await tts.setLanguage('ar-EG');
// //   // await tts.setSpeechRate(0.5);
// //   // await tts.setPitch(1.0);
// //   // await tts.setVolume(1.0);
// //   await tts.speak('لإنشاء حساب , اذكر إسمك فقط بعد سماع الصفارة');
// //   await tts.awaitSpeakCompletion(true);
// //   emit(EndTTS());
// //   await audioPlayer2.play(
// //     AssetSource('voices/sound1.mp3'),
// //     volume: 0.7,
// //   );
// //   audioPlayer2.onPlayerComplete.listen((event) {
// //     emit(ListeningToUser());
// //     listenToUser();
// //   });
// //   } else {
// //     // await tts.setLanguage('ar-EG');
// //     // await tts.setSpeechRate(0.5);
// //     // await tts.setPitch(1.0);
// //     // await tts.setVolume(1.0);
// //     await tts.speak('أهلا بعودتك $userName');
// //     await tts.awaitSpeakCompletion(true);
// //     playWelcomeAudio();
// //   }
// }
//
// void listenToUser() async {
//   var available = await speechToText.initialize();
//   if (available) {
//     speechToText.listen(
//       onResult: (result) {
//         String userName = result.confidence > 0.5
//             ? result.recognizedWords
//             : ' ... جاري الاستماع ';
//         sl<MySharedPref>()
//             .putString(key: MySharedKeys.userName, value: userName);
//         if (result.finalResult == true) {
//           sayUserName();
//           emit(SayingUserName());
//         }
//       },
//       listenMode: ListenMode.search,
//       localeId: 'ar_EG',
//       listenFor: const Duration(seconds: 3),
//     );
//   }
// }
//
// void sayUserName() async {
//   await tts.speak('تم إنشاء حساب بإسم , ${sl<MySharedPref>().getString(key: MySharedKeys.userName)}');
//   await tts.awaitSpeakCompletion(true);
//   emit(EndCreating());
//   playWelcomeAudio();
// }
}
