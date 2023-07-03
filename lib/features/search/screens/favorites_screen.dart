import 'package:ebsar2/features/search/cubit/search_cubit.dart';
import 'package:ebsar2/features/search/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = SearchCubit.get(context);
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
                  'قائمة المفضلة لديك',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Changa_SemiBold',
                  ),
                ),
              ),
              body: ListView.builder(
                itemCount: cubit.books.length,
                itemBuilder: (context, index) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.20,
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      margin: const EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: const Color(0xfff6eded),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(cubit.books[index].image.bookImage),
                                  fit: BoxFit.fill,
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Text(cubit.books[index].name ,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontFamily: 'Changa_SemiBold',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text('الكاتب تشارلز دويج' ,
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 10,
                                    fontFamily: 'Changa_SemiBold',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
