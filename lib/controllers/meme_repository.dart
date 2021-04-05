import 'dart:io';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:maymay/constants.dart';
import 'package:maymay/models/meme_model.dart';

class MemeRepository {
  static final Dio _dio = Dio();

  /// Fetch memes
  Future<MemeModel> fetchMemes({int count}) async {
    final Response response = await _dio.get(Const.apiUrl + "/${count ?? 5}");
    return MemeModel.fromJson(response.data);
  }

  /// Share one meme
  Future<void> shareMeme(Meme meme) async {
    final memeFile = await getMemeFile(meme);
    await Share.file(
        '', memeFile.keys.first, memeFile.values.first, 'image/jpg');
  }

  /// Get meme in bytes from provided model
  Future<Map<String, List<int>>> getMemeFile(Meme meme) async {
    final request = await HttpClient().getUrl(Uri.parse(meme.url));
    final HttpClientResponse response = await request.close();
    final Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    final String ext = meme.url.split(".").last;
    return {'${meme.hashCode}.$ext': bytes};
  }

  /// Fetch multiple memes and return as bytes and title
  Future<Map<String, List<int>>> getMemes() async {
    final MemeModel memeModel = await fetchMemes();
    final Map<String, List<int>> memeFiles = {};
    for (int i = 0; i < memeModel.memes.length; i++) {
      final bytes = await getMemeFile(memeModel.memes[i]);
      memeFiles[bytes.keys.first] = bytes.values.first;
    }
    return memeFiles;
  }

  /// Share multiples files
  Future<void> shareMemes(Map<String, List<int>> memeFiles) async {
    await Share.files('meme bomb', memeFiles, 'image/jpg');
    return true;
  }

  Future<bool> downloadMeme(Meme meme) async {
    // Directory downloadsDirectory =
    //     await DownloadsPathProvider.downloadsDirectory;
    // final String savePath =
    //     downloadsDirectory.path + "/meme-1" + meme.url.split(".").last;
    // final Response respose = await _dio.download(meme.url, savePath);
    // if (respose != null) return true;
    return false;
  }
}
