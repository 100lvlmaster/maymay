import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maymay/blocs/home_page_bloc/home_page_bloc.dart';
import 'package:maymay/models/meme_model.dart';
import 'package:maymay/screens/meme_preview.dart';
import '../blocs/home_page_bloc/home_page_bloc.dart';

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

  /// Listen for end of list
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
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.black,
        //   centerTitle: true,
        //   title: Text('maymay'),
        //   actions: [
        //     IconButton(
        //       icon: Text(
        //         'x10',
        //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        //       ),
        //       onPressed: () => _homePageBloc.add(MemeBomb()),
        //     )
        //   ],
        // ),
        extendBodyBehindAppBar: true,
        body: BlocConsumer<HomePageBloc, HomePageState>(
          /// Listeners
          listenWhen: (prev, curr) => [
            DownloadResultState,
            DownloadingMeme,
            LoadingState,
            RemoveLoaderState
          ].contains(curr.runtimeType),
          listener: (context, state) {
            if (state is DownloadResultState) {
              final SnackBar snackBar = SnackBar(
                content: Text(state.message),
                backgroundColor: state.isSuccess ? Colors.green : Colors.red,
                behavior: SnackBarBehavior.floating,
                elevation: 40.0,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }

            if (state is DownloadingMeme) {
              final SnackBar snackBar = SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.blue,
                behavior: SnackBarBehavior.floating,
                elevation: 40.0,
                duration: Duration(milliseconds: 500),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            if (state is RemoveLoaderState) {
              Navigator.pop(context);
            }
            if (state is LoadingState) {
              _buildLoadingDialog();
            }
          },

          /// Builders
          buildWhen: (prev, curr) => ![
            DownloadResultState,
            DownloadingMeme,
            LoadingState,
            RemoveLoaderState
          ].contains(curr.runtimeType),
          builder: (context, state) {
            if (state is HomePageInitial) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is RenderMemes) {
              return _buildMemesList(state.memes, false);
            }
            if (state is AppendLoader) {
              return _buildMemesList(state.memes, true);
            }

            return Container();
          },
        ),
      ),
    );
  }

  void _buildLoadingDialog() => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );

  Widget _buildMemesList(MemeModel memes, bool showLoader) {
    return CustomScrollView(
      controller: _scrollController,
      shrinkWrap: true,
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.black,
          snap: true,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text('maymay'),
              IconButton(
                icon: Text(
                  'x10',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                onPressed: () => _homePageBloc.add(MemeBomb()),
              )
            ],
          ),
          floating: true,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              if (showLoader && i == memes.memes.length) {
                return Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return _buildMemeTile(memes, i);
            },
            childCount:
                showLoader ? memes.memes.length + 1 : memes.memes.length,
          ),
        ),
      ],
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        memes.memes[i].title ?? "",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.download_rounded),
                    onPressed: () =>
                        _homePageBloc.add(DownloadMemeEvent(memes.memes[i])),
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

  _pushToPreview(Meme meme) => Navigator.push(
      context, MaterialPageRoute(builder: (_) => MemePreview(meme)));
}
