class CardModel {
  String cardid;
  String carddesc;
  String caption;
  String pagecaption;
  String displayicon;
  String stransid;
  String datasource;
  String moreoption;
  String colorcode;

  CardModel(
      {this.cardid = "",
      this.carddesc = "",
      this.caption = "",
      this.pagecaption = "",
      this.displayicon = "",
      this.stransid = "",
      this.datasource = "",
      this.moreoption = "",
      this.colorcode = ""}); // String title;

  CardModel.fromJson(Map<String, dynamic> json)
      : cardid = json['cardid'].toString(),
        carddesc = json['carddesc'].toString() ?? "",
        caption = json['caption'].toString(),
        pagecaption = json['pagecaption'].toString(),
        displayicon = json['displayicon'].toString(),
        stransid = json['stransid'].toString(),
        datasource = json['datasource'].toString(),
        moreoption = json['moreoption'] ?? "",
        colorcode = json['colorcode'].toString() ?? "";

  // title = json['title'].toString() ?? "";

  // json['colorcode'].toString() == "" ? "#FFECE5" : (json['colorcode'].toString() == "null" ? "#FFECE5" : json['colorcode'].toString());

  Map<String, dynamic> toJson() => {
        'cardid': cardid,
        'carddesc': carddesc,
        'caption': caption,
        'pagecaption': pagecaption,
        'displayicon': displayicon,
        'stransid': stransid,
        'datasource': datasource,
        'moreoption': moreoption,
        'colorcode': colorcode,
        // 'title': title,
      };
}
