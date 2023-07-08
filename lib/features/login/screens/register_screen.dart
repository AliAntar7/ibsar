import 'package:ebsar2/features/login/cubit/login_cubit.dart';
import 'package:ebsar2/features/search/cubit/search_cubit.dart';
import 'package:ebsar2/features/search/screens/first_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var loginCubit = context.read<LoginCubit>();
    var searchCubit = context.read<SearchCubit>();
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is EndCreateAccount) {
          searchCubit.isListening = false;
          searchCubit.playWelcomeAudio();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FirstScreen(isComeAgain: false),
            ),
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: loginCubit.allowClick ? () {
            searchCubit.playWelcomeAudio();
            print('Tapped');
          } : null,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: const Color(0xFFFDEEA9),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 1,
                backgroundColor: const Color(0xFFFADC52),
                title: const Text(
                  'جاري تسجيل حساب جديد ...',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Changa_SemiBold',
                  ),
                ),
              ),
              body: Container(
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
                        const Text(
                          'اذكر اسمك فقط بعد سماع الصفارة ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                            fontFamily: 'Changa_SemiBold',
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
                        Expanded(
                          child: Row(
                            children: [
                              const Text(
                                'رقم تسجيل دخولك هو ',
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                  fontFamily: 'Changa_SemiBold',
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${loginCubit.userId}',
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontFamily: 'Changa_SemiBold',
                                ),
                              ),
                            ],
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
                        Expanded(
                          child: Row(
                            children: [
                              const Text(
                                 'تم تسجيل الحساب بإسم ',
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                  fontFamily: 'Changa_SemiBold',
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                loginCubit.userName,
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontFamily: 'Changa_SemiBold',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 170,
                    ),
                    if (state is StartListeningToUserName)
                    Container(
                      child:Lottie.asset(
                        'assets/lotties/searching4.json',
                        height: 280,
                        width: 350,
                        fit: BoxFit.fill,
                      )
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
