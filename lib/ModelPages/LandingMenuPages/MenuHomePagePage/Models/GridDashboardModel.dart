class ShortcutMenuDashboardModel {
  String icon;
  String caption;
  String count;
  String type;
  String name;
  String url;

  ShortcutMenuDashboardModel.fromJson(Map<String, dynamic> json)
      : icon = json["icon"] ?? "",
        caption = json["caption"] ?? "",
        count = json["count"] ?? "",
        type = json["type"] ?? "",
        name = json["name"] ?? "",
        url = json["url"] ?? "";

  toJson() {
    return {
      "icon": icon,
      "caption": caption,
      "count": count,
      "type": type,
      "name": name,
      "url": url,
    };
  }
}
