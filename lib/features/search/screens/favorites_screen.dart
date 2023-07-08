import 'package:ebsar2/features/category/cubit/category_cubit.dart';
import 'package:ebsar2/features/search/cubit/search_cubit.dart';
import 'package:ebsar2/features/search/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = SearchCubit.get(context);
    var categoryCubit = CategoryCubit.get(context);
    return BlocConsumer<SearchCubit, SearchState>(
      listener: (context, state) {
        if (state is SearchingDone1) {
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
        if (state is SearchingError1) {
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
                  cubit.listen();
                  cubit.stopTTS();
                }
              : null,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                elevation: 1,
                backgroundColor: const Color(0xFFFADC52),
                title: const Text(
                  'قائمة المفضلة لـ علي عنتر علي  ...',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Changa_SemiBold',
                  ),
                ),
              ),
              body: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(15),
                itemCount: cubit.myFavoriteBooks.length,
                itemBuilder: (context, index) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.20,
                      padding: const EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: Colors.grey[300],
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
                                  image: NetworkImage(
                                    'https://ebsar.website/public/uploads/books_images/3bkryt_mohmd.png',
                                  ),
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
                              //mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 100,
                                  child: Text(
                                    // categoryCubit.bookNames[index],
                                    'كتاب عبقرية محمد',
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
                                const Text(
                                  'الكاتب عباس محمود العقاد',
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
