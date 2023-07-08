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
              backgroundColor: const Color(0xFFFDEEA9),
              appBar: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                elevation: 1,
                backgroundColor: const Color(0xFFFADC52),
                title: Text(
                  'كتب تصنيف ${cubit.categoryText}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Changa_SemiBold',
                  ),
                ),
              ),
              body: ListView.separated(
                padding: const EdgeInsets.all(15),
                itemCount: cubit.bookNames.length,
                itemBuilder: (context, index) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.20,
                      padding: const EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: Colors.white70,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: ShapeDecoration(
                                color: Colors.grey[600],
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(cubit.bookImages[index]),
                                  fit: BoxFit.fill,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 100,
                                  child: Text(
                                    cubit.bookNames[index],
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'Changa_SemiBold',
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.black12,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  cubit.bookPublisher[index],
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 10,
                                    fontFamily: 'Changa_SemiBold',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ));
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
              ),
            ),
          ),
        );
      },
    );
  }
}
