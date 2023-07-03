part of 'login_cubit.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}
class StartPlayLoginAudio extends LoginState {}
class EndPlayLoginAudio extends LoginState {}
class SayingErrorID extends LoginState {
  final String message;
  const SayingErrorID({required this.message});
}
class LoginSuccessfully extends LoginState {}
class StartCreateAccount extends LoginState {}
class EndCreateAccount extends LoginState {}