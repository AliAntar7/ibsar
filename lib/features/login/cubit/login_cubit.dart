import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:ebsar2/core/di/di.dart';
import 'package:ebsar2/core/utils/pref.dart';
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
  bool clickIcon = false;
  bool allowClick = false;

  void audioLogin() async {
    emit(StartPlayLoginAudio());
    await loginAudioPlayer.play(AssetSource('voices/login2.mp3'));
    loginAudioPlayer.onPlayerComplete.listen((event) {
      allowClick = true;
      emit(EndPlayLoginAudio());
    });
  }

  SpeechToText speechToText = SpeechToText();

  String text = '';
  int? userId ;
  SearchCubit searchCubit = SearchCubit();

// register with api https://ebsar.website/api/register?users_id=757&user_name=solex

  Future<void> register() async {
    emit(RegisterLoading());
    print(userName);
    print(userId.toString());
    var response = await Dio().post(
        'https://ebsar.website/api/register?users_id=$userId&user_name=$userName');
    print(response.data);
    print(response.statusCode);
    print(response.statusMessage);
    if (response.statusCode == 200) {
      sl<MySharedPref>().putString(
          key: MySharedKeys.token, value: response.data['data']['token']);
      getUserData(
        userId: userId.toString(),
      );
      successRegister();
    } else {
      emit(RegisterError(message: response.data['message']));
    }
  }

  // login with api https://ebsar.website/api/login?users_id=757

  Future<void> login(String id) async {
    emit(LoginLoading());
    var response =
        await Dio().post('https://ebsar.website/api/login?users_id=$id');
    if (response.statusCode == 200) {
      sl<MySharedPref>().putString(
          key: MySharedKeys.token, value: response.data['data']['token']);
      getUserData(
        userId: id,
      );
      emit(LoginSuccessfully());
    } else {
      emit(LoginError(message: response.data['message']));
    }
  }

  // get method to get user data with api https://ebsar.website/api/user/757

  Future<void> getUserData(
      {required String userId}
      ) async {
    var response = await Dio().get('https://ebsar.website/api/user/$userId',
      options: Options(
        headers: {
          //Authorization
          'Authorization':
              'Bearer ${sl<MySharedPref>().getString(key: MySharedKeys.token)}'
        },
      ),
    );
    if (response.statusCode == 200) {
      print('user name is ${response.data}');
      sl<MySharedPref>().putString(
          key: MySharedKeys.userName,
          value: response.data['data']['user_name'].toString());
      sl<MySharedPref>().putString(
          key: MySharedKeys.userID, value: response.data['data']['users_id'].toString());
    } else {
      emit(LoginError(message: response.data['message']));
    }
  }

  void listenToUser() async {
    emit(StartListening());
    clickIcon = true;
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
            login(
              text,
            );
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

  AudioPlayer createAccountAudio = AudioPlayer();
  AudioPlayer createAccountAudio0 = AudioPlayer();
  FlutterTts tts = FlutterTts();

  void createAccount() async {
    emit(StartCreateAccount());
    Random random = Random();
    // RANDOM 3 NUMBERS FROM 100 TO 999
    userId = random.nextInt(800) + 100;
    await createAccountAudio.play(AssetSource('voices/register.mp3'));
    createAccountAudio.onPlayerComplete.listen((event) async {
      await createAccountAudio0.play(AssetSource('voices/sound1.mp3'));
    });
    createAccountAudio0.onPlayerComplete.listen((event) async {
      listenToUserName();
    });
  }

  String userName = '';

  void listenToUserName() async {
    emit(StartListeningToUserName());
    var available = await speechToText.initialize();
    if (available) {
      speechToText.listen(
        onResult: (result) {
          userName = result.confidence > 0.5
              ? result.recognizedWords
              : ' ... جاري الاستماع ';
          print(userName);
          if (result.finalResult == true) {
            emit(EndListeningToUserName());
            register();
          }
        },
        listenMode: ListenMode.search,
        localeId: 'ar_EG',
        listenFor: const Duration(seconds: 4),
      );
    }
  }

  void stopListening() {
    speechToText.stop();
    emit(StopListening());
  }

  void stopTTS() async {
    await tts.stop();
  }

  FlutterTts ttsSayUserID = FlutterTts();
  FlutterTts ttsSayUseName = FlutterTts();

  void successRegister() async {
    await ttsSayUserID.speak('تم إنشاء حساب بإسم $userName');
    await ttsSayUserID.awaitSpeakCompletion(true);
    await ttsSayUserID.speak('و رقم حسابك هو $userId');
    await ttsSayUserID.awaitSpeakCompletion(true);
    print(userId);
    print(userName);
    emit(EndCreateAccount());
    allowClick = true;
  }
}
