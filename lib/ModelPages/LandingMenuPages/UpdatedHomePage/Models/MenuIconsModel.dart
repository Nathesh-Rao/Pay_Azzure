import 'dart:convert';

class MenuIconsModel {
  final String? name;
  final String? link;

  MenuIconsModel({
    required this.name,
    required this.link,
  });

  factory MenuIconsModel.fromRawJson(String str) => MenuIconsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MenuIconsModel.fromJson(Map<String, dynamic> json) => MenuIconsModel(
        name: json["name"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "link": link,
      };
}
