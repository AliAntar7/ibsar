import 'package:ebsar2/features/login/cubit/login_cubit.dart';
import 'package:ebsar2/features/login/screens/register_screen.dart';
import 'package:ebsar2/features/search/cubit/search_cubit.dart';
import 'package:ebsar2/features/search/screens/first_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var loginCubit = context.read<LoginCubit>();
    var searchCubit = context.read<SearchCubit>();
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is SayingErrorID) {
          loginCubit.speechError(error: state.message);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is LoginSuccessfully) {
          searchCubit.playWelcomeAudio();
          searchCubit.isListening = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FirstScreen(isComeAgain: false),
            ),
          );
        }
        if (state is StartCreateAccount) {
          loginCubit.allowClick = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegisterScreen(),
            ),
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: null,
          onLongPressCancel: loginCubit.allowClick
              ? () {
                  print('long press cancel');
                  loginCubit.clickIcon = false;
                  loginCubit.stopListening();
                }
              : null,
          onLongPressDown: loginCubit.allowClick
              ? (LongPressDownDetails details) {
                  print('long press down');
                  loginCubit.clickIcon = true;
                  print(loginCubit.clickIcon);
                  loginCubit.listenToUser();
                }
              : null,
          onLongPressUp: loginCubit.allowClick
              ? () {
                  print('long press up');
                  loginCubit.clickIcon = false;
                  loginCubit.stopListening();
                }
              : null,
          onDoubleTap: loginCubit.allowClick
              ? () {
                  loginCubit.stopListening();
                  loginCubit.clickIcon = false;
                  loginCubit.createAccount();
                  print('DoubleTapped');
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
                  'أهلا بــك ...',
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
                          'لإنشاء حساب جديد اضغط مرتين على الشاشة',
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
                        const Expanded(
                          child: Text(
                            'إذا لديك حساب بالفعل اضغط ضغطة مطولة على الشاشة و اذكر رقمك فقط',
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
                      child: loginCubit.clickIcon ? Lottie.asset(
                        'assets/lotties/searching4.json',
                        height: 280,
                        width: 350,
                        fit: BoxFit.fill,
                      ) : Lottie.asset(
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
