import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maymay/controllers/meme_repository.dart';
import 'package:maymay/models/meme_model.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageInitial());

  @override
  Stream<HomePageState> mapEventToState(
    HomePageEvent event,
  ) async* {
    // First fetch
    if (event is FetchMemes) {
      final MemeModel meme = await MemeRepository().fetchMemes();
      yield RenderMemes(meme);
    }
    // Append Loader and fetch more
    if (event is FetchMoreMemes && state is RenderMemes) {
      RenderMemes result = state;
      yield AppendLoader(result.memes);
    }
    //
    if (event is FetchMoreMemes && state is AppendLoader) {
      AppendLoader result = state;
      result.memes.memes.addAll((await MemeRepository().fetchMemes()).memes);
      yield RenderMemes(result.memes);
    }
    //
    if (event is ShareMeme) {
      _shareMeme(event.meme);
    }
    //
    if (event is DownloadMemeEvent) {
      yield DownloadingMeme('Download meme, please wait');
      final bool result = await _downloadMeme(event.meme);
      //
      if (result) {
        yield DownloadResultState(result, 'Meme was downloaded successfully');
      } else {
        yield DownloadResultState(
            result, 'Could not download meme, please try again later');
      }
    }
    //
    if (event is MemeBomb) {
      yield LoadingState('Fetching meme, please wait');
      final result = await MemeRepository().getMemes();
      yield RemoveLoaderState();
      await MemeRepository().shareMemes(result);
    }
  }

  Future<bool> _downloadMeme(Meme meme) async {
    await MemeRepository().downloadMeme(meme);
    return true;
  }

  _shareMeme(Meme meme) async {
    add(Loading("preparing image for sharing, please wait"));
    MemeRepository().shareMeme(meme);
  }
}
