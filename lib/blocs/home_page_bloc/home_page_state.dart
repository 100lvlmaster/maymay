part of 'home_page_bloc.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object> get props => [];
}

class HomePageInitial extends HomePageState {}

class RenderMemes extends HomePageState {
  final MemeModel memes;
  const RenderMemes(this.memes);
}

class LoadingState extends HomePageState {
  final String message;
  const LoadingState(this.message);
}

class AppendLoader extends HomePageState {
  final MemeModel memes;
  const AppendLoader(this.memes);
}

class RemoveLoaderState extends HomePageState {
  const RemoveLoaderState();
}

class DownloadingMeme extends HomePageState {
  final String message;
  const DownloadingMeme(this.message);
}

class DownloadResultState extends HomePageState {
  final bool isSuccess;
  final String message;
  const DownloadResultState(this.isSuccess, this.message);
}
