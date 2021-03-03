// To parse this JSON data, do
//
//     final memeModel = memeModelFromJson(jsonString);

import 'dart:convert';

class MemeModel {
  MemeModel({
    this.count,
    this.memes,
  });

  final int count;
  final List<Meme> memes;

  factory MemeModel.fromRawJson(String str) =>
      MemeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MemeModel.fromJson(Map<String, dynamic> json) => MemeModel(
        count: json["count"] == null ? null : json["count"],
        memes: json["memes"] == null
            ? null
            : List<Meme>.from(json["memes"].map((x) => Meme.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count == null ? null : count,
        "memes": memes == null
            ? null
            : List<dynamic>.from(memes.map((x) => x.toJson())),
      };
}

class Meme {
  Meme({
    this.postLink,
    this.subreddit,
    this.title,
    this.url,
    this.nsfw,
    this.spoiler,
    this.author,
    this.ups,
    this.preview,
  });

  final String postLink;
  final Subreddit subreddit;
  final String title;
  final String url;
  final bool nsfw;
  final bool spoiler;
  final String author;
  final int ups;
  final List<String> preview;

  factory Meme.fromRawJson(String str) => Meme.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meme.fromJson(Map<String, dynamic> json) => Meme(
        postLink: json["postLink"] == null ? null : json["postLink"],
        subreddit: json["subreddit"] == null
            ? null
            : subredditValues.map[json["subreddit"]],
        title: json["title"] == null ? null : json["title"],
        url: json["url"] == null ? null : json["url"],
        nsfw: json["nsfw"] == null ? null : json["nsfw"],
        spoiler: json["spoiler"] == null ? null : json["spoiler"],
        author: json["author"] == null ? null : json["author"],
        ups: json["ups"] == null ? null : json["ups"],
        preview: json["preview"] == null
            ? null
            : List<String>.from(json["preview"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "postLink": postLink == null ? null : postLink,
        "subreddit":
            subreddit == null ? null : subredditValues.reverse[subreddit],
        "title": title == null ? null : title,
        "url": url == null ? null : url,
        "nsfw": nsfw == null ? null : nsfw,
        "spoiler": spoiler == null ? null : spoiler,
        "author": author == null ? null : author,
        "ups": ups == null ? null : ups,
        "preview":
            preview == null ? null : List<dynamic>.from(preview.map((x) => x)),
      };
}

enum Subreddit { MEMES }

final subredditValues = EnumValues({"memes": Subreddit.MEMES});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
