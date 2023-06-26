part of 'search_cubit.dart';

@immutable
abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}
class StartWelcomeAudio extends SearchState {}
class EndWelcomeAudio extends SearchState {}
class StartWelcomeBackAudio extends SearchState {}
class EndWelcomeBackAudio extends SearchState {}
class StartListening extends SearchState {}
class EndListening extends SearchState {}
class TTSPlay extends SearchState {}
class TTSDone extends SearchState {}
class SearchingLoading extends SearchState {}
class SearchingDone extends SearchState {}
class StopListening extends SearchState {}
class AudioPaused extends SearchState {}
class AudioResumed extends SearchState {}
class AudioStopped extends SearchState {}
class AudioPlaying extends SearchState {}
class AudioPlayed extends SearchState {}
class SearchingError extends SearchState {
  final String message;
  const SearchingError({required this.message});
}
