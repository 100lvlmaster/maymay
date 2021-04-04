import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maymay/models/meme_model.dart';

import '../controllers/meme_repository.dart';

class MemePreview extends StatelessWidget {
  final Meme meme;
  const MemePreview(this.meme, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              onPressed: () async => await MemeRepository().shareMeme(meme),
              icon: Icon(Icons.share_rounded),
            ),
            SizedBox(width: 5)
          ],
        ),
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: meme.url,
                  child: CachedNetworkImage(
                    imageUrl: meme.url,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Text(
                meme.title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
