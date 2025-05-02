import 'dart:convert';

class KpiListModel {
  final String? name;
  final dynamic value;
  final String? link;

  KpiListModel({
    required this.name,
    required this.value,
    required this.link,
  });

  factory KpiListModel.fromRawJson(String str) => KpiListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory KpiListModel.fromJson(Map<String, dynamic> json) => KpiListModel(
        name: json["name"],
        value: json["value"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
        "link": link,
      };
}
