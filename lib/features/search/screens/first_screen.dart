import 'package:audioplayers/audioplayers.dart';
import 'package:ebsar2/features/category/cubit/category_cubit.dart';
import 'package:ebsar2/features/category/screens/categories_screen.dart';
import 'package:ebsar2/features/search/cubit/search_cubit.dart';
import 'package:ebsar2/features/search/screens/favorites_screen.dart';
import 'package:ebsar2/features/search/screens/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class FirstScreen extends StatefulWidget {
  final bool isComeAgain;

  const FirstScreen({super.key, required this.isComeAgain});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.isComeAgain) {
      BlocProvider.of<SearchCubit>(context).playWelcomeBackAudio();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, SearchState>(
      listener: (context, state) {
        if (state is SearchingDone1) {
          if (context.read<SearchCubit>().book != null) {
            context.read<SearchCubit>().isListening = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          }
        }
        if (state is StartReadTheFavorites) {
          context.read<SearchCubit>().isListening = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FavoritesScreen(),
            ),
          );
        }
        if (state is SearchingError1) {
          context.read<SearchCubit>().speechError(error: state.message);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onLongPressCancel: context.read<SearchCubit>().isListening
              ? () {
                  print('long press cancel');
                  context.read<SearchCubit>().stopListening();
                  context.read<SearchCubit>().searchingIcon = false;
                  print(context.read<SearchCubit>().userId);
                  print(context.read<SearchCubit>().userName);
                  print(context.read<SearchCubit>().myFavoriteBooks);
                  context.read<SearchCubit>().text = 'قول اسم كتاب';
                }
              : null,
          onLongPressDown: context.read<SearchCubit>().isListening
              ? (LongPressDownDetails details) {
                  print('long press down');
                  context.read<SearchCubit>().listen();
                  /// TODO error come when this function called buz no tts play to stop it
                  context.read<SearchCubit>().stopTTS();
                }
              : null,
          onLongPressUp: context.read<SearchCubit>().isListening
              ? () {
                  print('long press up');
                  context.read<SearchCubit>().stopListening();
                  context.read<SearchCubit>().searchingIcon = false;
                  context.read<SearchCubit>().text = 'قول اسم كتاب';
                }
              : null,
          onTap: context.read<SearchCubit>().isListening
              ? () {
                  print('tap');
                  context.read<SearchCubit>().stopAudio();
                  context.read<SearchCubit>().searchingIcon = false;
                  context.read<SearchCubit>().text = 'قول اسم كتاب';
                }
              : null,
          onDoubleTap: context.read<SearchCubit>().isListening
              ? () {
                  print('double tapped');
                  context.read<SearchCubit>().stopListening();
                  context.read<SearchCubit>().speechToText.stop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoriesScreen(),
                    ),
                  );
                  CategoryCubit.get(context).readCategoriesName();
                }
              : null,
          onVerticalDragEnd: context.read<SearchCubit>().isListening
              ? context.read<SearchCubit>().isFavoritesEmpty()
                  ? (DragEndDetails details) {
                      context.read<SearchCubit>().stopListening();
                      print('no books in favorite');
                      context.read<SearchCubit>().noBookFavorite();
                      context.read<SearchCubit>().searchingIcon = false;
                      context.read<SearchCubit>().text =
                          'لا يوجد كتب مفضلة حتى الآن';
                    }
                  : (DragEndDetails details) {
                      context.read<SearchCubit>().stopListening();
                      print('yes there is books in favorite');
                      context.read<SearchCubit>().searchingIcon = false;
                      context.read<SearchCubit>().readTheFavorites();
                    }
              : null,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        context.read<SearchCubit>().text,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 40,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Lottie.asset(
                      context.read<SearchCubit>().searchingIcon
                          ? 'assets/lotties/searching1.json'
                          : 'assets/lotties/command.json',
                      height: 200,
                      width: 200,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
