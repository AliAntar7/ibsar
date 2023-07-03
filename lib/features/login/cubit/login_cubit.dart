import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:ebsar2/features/search/cubit/search_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  AudioPlayer loginAudioPlayer = AudioPlayer();
  AudioPlayer audioPlayer = AudioPlayer();
  bool allowClick = false;

  void audioLogin() async {
    emit(StartPlayLoginAudio());
    await loginAudioPlayer.play(AssetSource('voices/login1.mp3'));
    loginAudioPlayer.onPlayerComplete.listen((event) {
      audioPlayer.play(AssetSource('voices/sound1.mp3'));
      allowClick = true;
      emit(EndPlayLoginAudio());
    });
    audioPlayer.onPlayerComplete.listen((event) {
      listenToUser();
    });
  }

  SpeechToText speechToText = SpeechToText();

  String text = '';
  int userId = 579;
  SearchCubit searchCubit = SearchCubit();

  void listenToUser() async {
    var available = await speechToText.initialize();
    if (available) {
      speechToText.listen(
        onResult: (result) {
          text = result.confidence > 0.5
              ? result.recognizedWords
              : ' ... جاري الاستماع ';
          text = text.replaceAll(' ', '');
          print(text);
          if (result.finalResult == true) {
            if (text != userId.toString()) {
              emit(SayingErrorID(message: 'الرقم الذي قلته غير صحيح $text'));
            }else {
              emit(LoginSuccessfully());
            }
          }
        },
        listenMode: ListenMode.search,
        localeId: 'ar_EG',
        listenFor: const Duration(seconds: 6),
      );
    }
  }

  void speechError({required String error}) async {
    await tts.speak(error);
    //await tts.awaitSpeakCompletion(true);
  }

  int id = 0;
  AudioPlayer createAccountAudio = AudioPlayer();
  FlutterTts tts = FlutterTts();
  void createAccount() async {
    emit(StartCreateAccount());
    Random random = Random();
    id = random.nextInt(1000);
    await tts.speak('لإنشاء حساب جديد , اذكر اسمكْ فقط بعد سماع الصفارة ');
    await tts.awaitSpeakCompletion(true);
    await createAccountAudio.play(AssetSource('voices/sound1.mp3'));
    createAccountAudio.onPlayerComplete.listen((event) async {
      listenToUserName();
    });
  }

  FlutterTts ttsSayUserID = FlutterTts();
  String userName = '';
  void listenToUserName() async {
    var available = await speechToText.initialize();
    if (available) {
      speechToText.listen(
        onResult: (result) {
          userName = result.confidence > 0.5
              ? result.recognizedWords
              : ' ... جاري الاستماع ';
          print(userName);
          if (result.finalResult == true) {
            tts.speak('تم إنشاء حساب بإسم $userName');
            tts.awaitSpeakCompletion(true);
            ttsSayUserID.speak('و رقم حسابك هو $id');
            ttsSayUserID.awaitSpeakCompletion(true);
            print(id);
            print(userName);
            emit(EndCreateAccount());
            allowClick = true;
          }
        },
        listenMode: ListenMode.search,
        localeId: 'ar_EG',
        listenFor: const Duration(seconds: 4),
      );
    }
  }
}



