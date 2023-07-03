import 'package:ebsar2/core/constants/app_string.dart';
import 'package:ebsar2/features/category/cubit/category_cubit.dart';
import 'package:ebsar2/features/search/cubit/search_cubit.dart';
import 'package:ebsar2/features/search/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = CategoryCubit.get(context);
    var cubit2 = SearchCubit.get(context);
    return BlocConsumer<CategoryCubit, CategoryState>(
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
          onDoubleTap: cubit.isListening
              ? () {
                  print('double tap');
                  cubit2.listen();
                  cubit2.stopTTS();
                }
              : null,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                elevation: 1,
                title: Text(
                  'كتب تصنيف ${cubit.categoryText}',
                ),
              ),
              body: Container(
                color: Colors.grey[300],
                child: GridView.count(
                  //shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 5.0,
                  padding: const EdgeInsets.all(5.0),
                  crossAxisSpacing: 5.0,
                  childAspectRatio: 1 / 1.30,
                  children: List.generate(
                    cubit.bookNames.length,
                        (index) => Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  cubit.bookImages[index],
                                  //fit: BoxFit.cover,
                                  width: 150,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Text(
                                  cubit.bookNames[index],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
