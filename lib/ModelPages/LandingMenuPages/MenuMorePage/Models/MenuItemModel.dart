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

class MenuItemNewmModel {
  String name;
  String caption;
  String type;
  String visible;
  String img;
  String parent;
  String levelno;
  String pagetype;
  String intview;
  String icon;
  String url;
  String parent_tree = "";
  List<MenuItemNewmModel> childList = [];

  MenuItemNewmModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        caption = json['caption'],
        type = json['type'],
        visible = json['visible'],
        img = json['img'] ?? "",
        parent = json['parent'] ?? "",
        levelno = json['levelno'].toString() ?? "",
        pagetype = json['pagetype'] ?? "",
        intview = json['intview'] ?? "",
        icon = json['icon'] ?? "",
        url = json['url'] ?? "",
        parent_tree = json['parent_tree'] ?? "",
        childList = json['childList'] ?? [];

  Map<String, dynamic> toJson() => {
        'name': name,
        'caption': caption,
        'type': type,
        'visible': visible,
        'img': img,
        'parent': parent,
        'levelno': levelno,
        'pagetype': pagetype,
        'intview': intview,
        'icon': icon,
        'url': url,
      };

  @override
  String toString() {
    // TODO: implement toString
    return "name:$name, caption:$caption, type:$type, visible:$visible, img:$img, parent:$parent, levelno:$levelno, pagetype:$pagetype, intview:$intview, icon:$icon, url:$url,  parent_tree:$parent_tree, childList:$childList ";
  }
}
