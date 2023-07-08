import 'package:ebsar2/core/constants/app_string.dart';
import 'package:ebsar2/features/category/cubit/category_cubit.dart';
import 'package:ebsar2/features/category/screens/books_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = CategoryCubit.get(context);
    return BlocConsumer<CategoryCubit, CategoryState>(
      listener: (context, state) {
        if (state is SearchingForBooksByCategoryNameError) {
          cubit.speechError(error: state.message);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is SearchingForBooksByCategoryNameDone) {
          //cubit.tts.stop();
          cubit.isListening = false;
          cubit.readBookName();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BooksScreen(),
            ),
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onDoubleTap: cubit.isListening
              ? () {
                  print('double tap');
                  cubit.listenToCategoryName();
                  cubit.tts.stop();
                }
              : null,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: const Color(0xFFFDEEA9),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 1,
                backgroundColor: const Color(0xFFFADC52),
                title: const Text(
                  'قائمة التصنيــفات ...',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Changa_SemiBold',
                  ),
                ),
              ),
              body: GridView.count(
                //shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                padding: const EdgeInsets.all(10.0),
                crossAxisSpacing: 10.0,
                childAspectRatio: 1 / 1,
                children: List.generate(
                  cubit.categoriesNames.length,
                  (index) => Container(
                    height: MediaQuery.of(context).size.height * 0.20,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                      color: Colors.white70,
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 8,
                          offset: const Offset(5, 7),
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      image: DecorationImage(
                        image: NetworkImage(
                          cubit.categoriesImages[index],
                        ),
                        fit: BoxFit.fill,
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
