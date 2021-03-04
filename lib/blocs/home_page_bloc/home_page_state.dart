part of 'home_page_bloc.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object> get props => [];
}

class HomePageInitial extends HomePageState {}

class RenderMemes extends HomePageState {
  final MemeModel memes;
  final bool showLoader;
  const RenderMemes(this.memes, this.showLoader);
}

class LoadingImage extends HomePageState {
  final String message;
  const LoadingImage(this.message);
}

class AppendLoader extends HomePageState {
  final MemeModel memes;
  const AppendLoader(this.memes);
}
