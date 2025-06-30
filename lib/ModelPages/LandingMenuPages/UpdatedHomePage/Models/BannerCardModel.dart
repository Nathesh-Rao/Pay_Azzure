import 'dart:convert';

class BannerCard {
  String? title;
  String? subtitle;
  String? time;
  String? image;
  String? link;

  BannerCard({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.image,
    required this.link,
  });

  factory BannerCard.fromRawJson(String str) => BannerCard.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BannerCard.fromJson(Map<String, dynamic> json) => BannerCard(
        title: json["title"],
        subtitle: json["subtitle"],
        time: json["time"],
        image: json["image"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "time": time,
        "image": image,
        "link": link,
      };
}
