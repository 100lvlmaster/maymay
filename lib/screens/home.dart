import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maymay/blocs/home_page_bloc/home_page_bloc.dart';
import 'package:maymay/models/meme_model.dart';
import 'package:maymay/screens/meme_preview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  HomePageBloc _homePageBloc;
  @override
  void initState() {
    super.initState();
    _homePageBloc = BlocProvider.of<HomePageBloc>(context);
    _homePageBloc.add(FetchMemes());
    _scrollListener();
  }

  _scrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        _homePageBloc.add(FetchMoreMemes());
      }
    });
  }

  @override
  void dispose() {
    _homePageBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: BlocBuilder<HomePageBloc, HomePageState>(
              buildWhen: (prev, curr) => curr is! LoadingImage,
              builder: (context, state) {
                if (state is HomePageInitial) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is RenderMemes) {
                  print(state.showLoader);
                  return _buildMemesList(state.memes, state.showLoader);
                }
                return Container();
              },
            ),
          ),
          // BlocListener(
          //   listenWhen: (prev, curr) => curr is LoadingImage,
          //   listener: (context, state) => _showLoader(context, state.message),
          //   child: Container(),
          // ),
        ],
      ),
    );
  }

  Container _buildMemesList(MemeModel memes, bool showLoader) {
    return Container(
      color: Colors.black,
      child: ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: showLoader ? memes.memes.length + 1 : memes.memes.length,
        itemBuilder: (context, i) {
          if (showLoader && i == memes.memes.length) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return _buildMemeTile(memes, i);
        },
      ),
    );
  }

  Padding _buildMemeTile(MemeModel memes, int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          color: Colors.grey[200],
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _pushToPreview(memes.memes[i]),
                child: Hero(
                  tag: memes.memes[i].url,
                  child: CachedNetworkImage(
                    imageUrl: memes.memes[i].url,
                    placeholder: (context, _) => Container(
                      height: 150,
                      width: double.maxFinite,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.download_rounded),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () =>
                        _homePageBloc.add(ShareMeme(memes.memes[i])),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // _showLoader(BuildContext context, String msg) {
  //   final SnackBar snackBar = SnackBar(
  //     content: Text(msg),
  //   );
  //   Scaffold.of(context).showSnackBar(snackBar);
  // }

  _pushToPreview(Meme meme) => Navigator.push(
      context, MaterialPageRoute(builder: (_) => MemePreview(meme)));
}
