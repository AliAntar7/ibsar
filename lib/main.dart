import 'dart:convert';
import 'dart:io';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ebsar2/core/di/di.dart';
import 'package:ebsar2/core/models/book_model.dart';
import 'package:ebsar2/core/utils/observer.dart';
import 'package:ebsar2/core/utils/pref.dart';
import 'package:ebsar2/features/category/cubit/category_cubit.dart';
import 'package:ebsar2/features/login/cubit/login_cubit.dart';
import 'package:ebsar2/features/login/screens/welcome_screen.dart';
import 'package:ebsar2/features/search/cubit/search_cubit.dart';
import 'package:ebsar2/features/search/screens/favorites_screen.dart';
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
      //print(response.body.toString());
      return books;
    } catch (error) {
      print('the error -----------> $error');
      return [];
    }
  }
}

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  HttpOverrides.global = MyHttpOverrides();
  init();
  await sl<MySharedPref>().initSP();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => LoginCubit()..audioLogin(),
    ),
    BlocProvider(
      create: (context) => SearchCubit(),
    ),
    BlocProvider(
        lazy: false,
        create: (context) => CategoryCubit()..getCategories()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    GetBooks.getBooks().then((value) {
      if (value.isNotEmpty) {
        print(
            '---------------------- The data of books is found successfully ----------------------');
      } else {
        print(
            '---------------------- The data of books is not found ----------------------');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FavoritesScreen(),
      debugShowCheckedModeBanner: false,
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
      nextScreen: const WelcomeScreen(),
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
