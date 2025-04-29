class MenuFolderModel {
  String? cardid;
  String? caption;
  String? groupfolder;
  String? grppageid;
  String? paneltype;
  String? target;

  MenuFolderModel({
    this.cardid = "",
    this.caption = "",
    this.groupfolder = "",
    this.grppageid = "",
    this.paneltype = "",
    this.target = "",
  });

  MenuFolderModel.fromJson(dynamic json) {
    cardid = json['cardid'] ?? "";
    caption = json['caption'] ?? "";
    groupfolder = json['groupfolder'] ?? "";
    grppageid = json['grppageid'] ?? "";
    paneltype = json['paneltype'] ?? "";
    target = json['target'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cardid'] = cardid;
    map['caption'] = caption;
    map['groupfolder'] = groupfolder;
    map['grppageid'] = grppageid;
    map['paneltype'] = paneltype;
    map['target'] = target;
    return map;
  }
}
