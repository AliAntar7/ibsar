import 'package:ebsar2/features/login/cubit/login_cubit.dart';
import 'package:ebsar2/features/login/screens/register_screen.dart';
import 'package:ebsar2/features/search/cubit/search_cubit.dart';
import 'package:ebsar2/features/search/screens/first_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          onDoubleTap: loginCubit.allowClick ? () {
            loginCubit.speechToText.stop();
            loginCubit.createAccount();
            print('DoubleTapped');
          } : null,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Welcome'),
              ),
              body: Column(
                children: [
                  Text(
                    'مرحبا بك في تطبيق ابصار',
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'قم بتسجيل الدخول برقم ${loginCubit.text}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
