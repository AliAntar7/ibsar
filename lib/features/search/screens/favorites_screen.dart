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
                backgroundColor: Color(0xFFFADC52),
                title: const Text(
                  'قائمة المفضلة لديك',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Changa_SemiBold',
                  ),
                ),
              ),
              body: Container(
                color: Colors.white,
                child: GridView.count(
                  crossAxisCount: 1,
                  mainAxisSpacing: 13.0,
                  padding: const EdgeInsets.all(13.0),
                  crossAxisSpacing: 13.0,
                  childAspectRatio: 1 / 0.4,
                  children: List.generate(
                    cubit.books.length,
                        (index) => Container(
                          width: double.infinity,
                          //height: 40,
                          decoration: ShapeDecoration(
                            color: Color(0x66BFD0D1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Container(
                                  width: 120,
                                  //height: 80,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage("${cubit.books[index].image.bookImage}"),
                                      fit: BoxFit.fill,
                                    ),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${cubit.books[index].name}' ,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Changa_SemiBold',
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
                              ],
                            ),
                          )
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
