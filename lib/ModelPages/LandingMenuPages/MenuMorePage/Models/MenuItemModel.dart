class MenuItemModel {
  String rootnode;
  String name;
  String caption;
  String type;
  String icon;
  String pagetype;
  String props;
  String img;
  String levelno;
  String intview;
  String url;

  MenuItemModel.fromJson(Map<String, dynamic> json)
      : rootnode = json['rootnode'],
        name = json['name'],
        caption = json['caption'],
        type = json['type'],
        icon = json['icon'] ?? "",
        pagetype = json['pagetype'],
        props = json['props'] ?? "",
        img = json['img'] ?? "",
        levelno = json['levelno'].toString() ?? "",
        intview = json['intview'] ?? "",
        url = json['url'] ?? "";

  Map<String, dynamic> toJson() => {
        'rootnode': rootnode,
        'name': name,
        'caption': caption,
        'type': type,
        'icon': icon,
        'pagetype': pagetype,
        'props': props,
        'img': img,
        'levelno': levelno,
        'intview': intview,
        'url': url,
      };
}
