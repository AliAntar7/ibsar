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
class LoginLoading extends LoginState {}
class LoginError extends LoginState {
  final String message;
  const LoginError({required this.message});
}

class RegisterSuccessfully extends LoginState {}
class RegisterLoading extends LoginState {}
class RegisterError extends LoginState {
  final String message;
  const RegisterError({required this.message});
}class StartCreateAccount extends LoginState {}
class EndCreateAccount extends LoginState {}
class StartListening extends LoginState {}
class StopListening extends LoginState {}
class AudioStopped extends LoginState {}
class StartListeningToUserName extends LoginState {}
class EndListeningToUserName extends LoginState {}