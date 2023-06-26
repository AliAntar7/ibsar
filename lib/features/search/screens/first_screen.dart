import 'package:ebsar2/features/category/cubit/category_cubit.dart';
import 'package:ebsar2/features/category/screens/categories_screen.dart';
import 'package:ebsar2/features/search/cubit/search_cubit.dart';
import 'package:ebsar2/features/search/screens/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = SearchCubit.get(context);
    var cubit2 = CategoryCubit.get(context);
    return BlocConsumer<SearchCubit, SearchState>(
      listener: (context, state) {
        if (state is SearchingDone) {
          if (cubit.book != null) {
            cubit.isListening = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          }
        }
        if (state is SearchingError) {
          cubit.speechError(error: state.message);
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
          onLongPressCancel: cubit.isListening
              ? () {
                  print('long press cancel');
                  cubit.stopListening();
                  cubit.searchingIcon = false;
                }
              : null,
          onLongPressDown: cubit.isListening
              ? (LongPressDownDetails details) {
                  print('long press down');
                  cubit.listen();
                  cubit.searchingIcon = true;
                  cubit.stopTTS();
                }
              : null,
          onLongPressUp: cubit.isListening
              ? () {
                  print('long press up');
                  cubit.stopListening();
                  cubit.searchingIcon = false;
                }
              : null,
          onTap: cubit.isListening
              ? () {
                  print('tap');
                  cubit.stopAudio();
                  cubit.searchingIcon = false;
                }
              : null,
          onDoubleTap: cubit.isListening
              ? () {
                  print('double tap');
                  cubit.stopListening();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoriesScreen(),
                    ),
                  );
                  cubit2.readCategoriesName();
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
                        cubit.text,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 40,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Lottie.asset( cubit.searchingIcon
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
