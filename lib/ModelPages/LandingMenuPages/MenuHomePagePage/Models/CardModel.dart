class CardModel {
  String cardid;
  String caption;
  String pagecaption;
  String displayicon;
  String stransid;
  String datasource;
  String moreoption;
  String colorcode;

  CardModel.fromJson(Map<String, dynamic> json)
      : cardid = json['cardid'].toString(),
        caption = json['caption'].toString(),
        pagecaption = json['pagecaption'].toString(),
        displayicon = json['displayicon'].toString(),
        stransid = json['stransid'].toString(),
        datasource = json['datasource'].toString(),
        moreoption = json['moreoption'] ?? "",
        colorcode = json['colorcode'].toString();

  // json['colorcode'].toString() == "" ? "#FFECE5" : (json['colorcode'].toString() == "null" ? "#FFECE5" : json['colorcode'].toString());

  Map<String, dynamic> toJson() => {
        'cardid': cardid,
        'caption': caption,
        'pagecaption': pagecaption,
        'displayicon': displayicon,
        'stransid': stransid,
        'datasource': datasource,
        'moreoption': moreoption,
        'colorcode': colorcode,
      };
}
