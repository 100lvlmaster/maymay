part of 'home_page_bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];
}

class FetchMemes extends HomePageEvent {}

class FetchMoreMemes extends HomePageEvent {}

class ShareMeme extends HomePageEvent {
  final Meme meme;
  const ShareMeme(this.meme);
}

class DownloadMemeEvent extends HomePageEvent {
  final Meme meme;
  const DownloadMemeEvent(this.meme);
}

class MemeBomb extends HomePageEvent {
  const MemeBomb();
}

class Loading extends HomePageEvent {
  final String message;
  const Loading(this.message);
}

class LoadMoreMemes extends HomePageEvent {
  final MemeModel memes;
  const LoadMoreMemes(this.memes);
}
