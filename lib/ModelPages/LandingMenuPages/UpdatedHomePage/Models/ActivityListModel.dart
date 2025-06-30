import 'dart:convert';

class ActivityListModel {
  final String? title;
  final String? username;
  final String? calledon;
  final String? link;

  ActivityListModel({
    required this.title,
    required this.username,
    required this.calledon,
    required this.link,
  });

  factory ActivityListModel.fromRawJson(String str) => ActivityListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ActivityListModel.fromJson(Map<String, dynamic> json) => ActivityListModel(
        title: json["title"],
        username: json["username"],
        calledon: json["calledon"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "username": username,
        "calledon": calledon,
        "link": link,
      };
}
