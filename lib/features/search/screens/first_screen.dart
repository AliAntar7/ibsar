import 'package:ebsar2/core/di/di.dart';
import 'package:ebsar2/core/utils/pref.dart';
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
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xFFFDEEA9),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 1,
              backgroundColor: const Color(0xFFFADC52),
              title:
                  sl<MySharedPref>().getString(key: MySharedKeys.token) != ''
                      ? Text(
                          'مرحباً بك ...  ${sl<MySharedPref>().getString(key: MySharedKeys.userName)}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Changa_SemiBold',
                          ),
                        )
                      : Text(
                          'الصفحة الرئيسية ...',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Changa_SemiBold',
                          ),
                        ),
              actions: [
                IconButton(
                  onPressed: () {
                    sl<MySharedPref>().clearShared();
                    print('SharedPref cleared');
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            body: GestureDetector(
              onLongPressCancel: context.read<SearchCubit>().isListening
                  ? () {
                print('long press cancel');
                context.read<SearchCubit>().stopListening();
                context.read<SearchCubit>().searchingIcon = false;
                // print(context.read<SearchCubit>().userId);
                // print(context.read<SearchCubit>().userName);
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
              child: Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Lottie.asset(
                          'assets/lotties/attention.json',
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Expanded(
                          child: Text(
                            'للبحث عن كتاب اضغط ضغطة مطولة على الشاشة و اذكر اسم الكتاب',
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontFamily: 'Changa_SemiBold',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Lottie.asset(
                          'assets/lotties/attention.json',
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Expanded(
                          child: Text(
                            'لسماع قائمة التصنيفات لدينا اضغط مرتين على الشاشة',
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontFamily: 'Changa_SemiBold',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Lottie.asset(
                          'assets/lotties/attention.json',
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Expanded(
                          child: Text(
                            'لسماع قائمة المفضلة لديك اسحب الشاشة للأعلى ',
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontFamily: 'Changa_SemiBold',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 170,
                    ),
                    Container(
                      child: context.read<SearchCubit>().searchingIcon
                          ? Lottie.asset(
                              'assets/lotties/searching3.json',
                              height: 280,
                              width: 280,
                              fit: BoxFit.fill,
                            )
                          : Lottie.asset(
                              'assets/lotties/click_here.json',
                              height: 280,
                              width: 280,
                              fit: BoxFit.fill,
                            ),
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
