import 'dart:convert';

class NewsCardModel {
  final String? title;
  final String? subtitle;
  final String? time;
  final String? link;
  final String? image;

  NewsCardModel({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.link,
    required this.image,
  });

  factory NewsCardModel.fromRawJson(String str) => NewsCardModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NewsCardModel.fromJson(Map<String, dynamic> json) => NewsCardModel(
        title: json["title"],
        subtitle: json["subtitle"],
        time: json["time"],
        link: json["link"],
        image: json["image"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "time": time,
        "link": link,
        "image": image,
      };
}
