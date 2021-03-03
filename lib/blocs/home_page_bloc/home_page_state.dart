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

class LoadingImage extends HomePageState {
  final String message;
  const LoadingImage(this.message);
}
