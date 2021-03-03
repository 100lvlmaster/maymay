import 'dart:io';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:maymay/constants.dart';
import 'package:maymay/models/meme_model.dart';

class MemeRepository {
  static final Dio _dio = Dio();
  Future<MemeModel> fetchMemes() async {
    final Response response = await _dio.get(Const.apiUrl + "/10");
    return MemeModel.fromJson(response.data);
  }

  Future<void> shareMeme(Meme meme) async {
    final request = await HttpClient().getUrl(Uri.parse(meme.url));
    final HttpClientResponse response = await request.close();
    final Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    final String ext = meme.url.split(".").last;
    await Share.file(
        '', '${meme.title.replaceAll(" ", "_")}.$ext', bytes, 'image/jpg');
  }
}
