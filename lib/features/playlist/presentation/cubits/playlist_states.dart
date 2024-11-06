abstract class PlaylistState {}

class PlaylistInitial extends PlaylistState {}

class PlaylistLoading extends PlaylistState {}

class PlaylistLoaded extends PlaylistState {}

class PlaylistError extends PlaylistState {
  final String message;
  PlaylistError(this.message);
}
