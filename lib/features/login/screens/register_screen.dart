import 'package:ebsar2/features/login/cubit/login_cubit.dart';
import 'package:ebsar2/features/search/cubit/search_cubit.dart';
import 'package:ebsar2/features/search/screens/first_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              appBar: AppBar(
                title: Text('صفحة تسجيل حساب جديد'),
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
                    'رقم تسجيل دخولك هو ${loginCubit.id}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'تم إنشاء حساب بإسم ${loginCubit.userName}',
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
