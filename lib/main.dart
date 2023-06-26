import 'dart:convert';
import 'dart:io';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ebsar2/core/models/book_model.dart';
import 'package:ebsar2/core/utils/observer.dart';
import 'package:ebsar2/features/category/cubit/category_cubit.dart';
import 'package:ebsar2/features/search/cubit/search_cubit.dart';
import 'package:ebsar2/features/search/screens/first_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;


class GetBooks {
  static List<BookModel> books = [];
  static Future<List<BookModel>> getBooks() async {
    try {
      Uri url = Uri.parse('https://ebsar.website/api/books');
      http.Response response = await http.get(url);
      var data = jsonDecode(response.body);
      data['data'].forEach((element) {
        books.add(BookModel.fromJson(element));
      });
      print(response.body.toString());
      return books;

    } catch (error) {
      print('the $error');
      return [];
    }
  }
}
void main() {
  Bloc.observer = MyBlocObserver();
  HttpOverrides.global = MyHttpOverrides();
  GetBooks.getBooks();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchCubit()..playWelcomeAudio(),
        ),
        BlocProvider(
          create: (context) => CategoryCubit()
            ..getCategories()
        ),
      ],
      child: const MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset(
        'assets/lotties/splash.json',
      ),
      backgroundColor: Colors.white,
      nextScreen: const FirstScreen(),
      splashIconSize: 300,
      duration: 4000,
      splashTransition: SplashTransition.fadeTransition,
      //pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(seconds: 1),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
