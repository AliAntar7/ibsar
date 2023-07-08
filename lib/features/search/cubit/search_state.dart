part of 'search_cubit.dart';


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
class TTSPlay1 extends SearchState {}
class TTSDone1 extends SearchState {}
class SearchingLoading extends SearchState {}
class SearchingDone1 extends SearchState {}
class StopListening extends SearchState {}
class AudioPaused extends SearchState {}
class AudioResumed extends SearchState {}
class AudioPlaying extends SearchState {}
class AudioPlayed extends SearchState {}
class AudioStopped extends SearchState {}
class PlayPositionUserStopped extends SearchState {}
class RemoveFromFavorite extends SearchState {}
class AddingToFavorites extends SearchState {}
class AddedToFavorites extends SearchState {}
class StartReadTheFavorites extends SearchState {}
class EndReadTheFavorites extends SearchState {}
class StartCreating extends SearchState {}
class EndCreating extends SearchState {}
class SayingUserName extends SearchState {}
class ListeningToUser extends SearchState {}
class EndListenToUser extends SearchState {}
class EndTTS extends SearchState {}
class SearchingError1 extends SearchState {
  final String message;
  const SearchingError1({required this.message});
}


