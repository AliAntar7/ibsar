import 'dart:ui';

import 'package:ebsar2/features/search/cubit/search_cubit.dart';
import 'package:ebsar2/features/search/screens/first_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = SearchCubit.get(context);
    return BlocConsumer<SearchCubit, SearchState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: GestureDetector(
            onTap: cubit.isListening ? () {
              cubit.stopAudio();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FirstScreen(
                      isComeAgain: true,
                    ),
                  ),
                      (route) => false);
              cubit.text = ' ابحث عن كتاب اخر';
              cubit.searchingIcon = false;
            } : null,
            onDoubleTap: cubit.isListening ? (){
              cubit.playAudio();
            } : null,
            onVerticalDragStart: cubit.isListening
                ? (DragStartDetails details) {
              print('vertical drag start----------');
            }
                : null,
            onVerticalDragEnd: cubit.isListening
                ? (DragEndDetails details) {
              print('vertical drag end-----------------');
              cubit.makeItFavorite();
            }
                : null,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: const Color(0xFFFADC52),
                title: Text(
                  'أنت الآن تستمع إلى ${cubit.book!.name} ...',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Changa_SemiBold',
                  ),
                ),
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(cubit.book!.image.bookImage),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 20,
                    sigmaY: 20,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black.withOpacity(0.1),
                    child: SafeArea(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 90,
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 20,
                            ),
                            height: MediaQuery.of(context).size.height * 0.32,
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 25,
                                        offset: const Offset(8, 8),
                                        spreadRadius: 3,
                                      ),
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 25,
                                        offset: const Offset(-8, -8),
                                        spreadRadius: 3,
                                      )
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      cubit.book!.image.bookImage,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.3),
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.3),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            cubit.book!.name,
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Changa_SemiBold',
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xfffff8ee),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                ),
                              ),
                              padding: const EdgeInsets.only(
                                left: 30,
                                right: 30,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                          'لإيقاف الكتاب أو تشغيله اضغط مرتين على الشاشة',
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
                                          'للعودة لصفحة الرئيسية اضغط ضغطة واحدة على الشاشة',
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
                                          'لإضافة الكتاب إلى المفضلة اسحب الشاشة للأعلى ',
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
                                ],
                              ),
                            ),
                          )
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
