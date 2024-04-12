class CardOptionModel {
  String cardname;
  String cardicon;
  String caption;
  String text;
  String link;
  String id;

  CardOptionModel.fromJson(Map<String, dynamic> json)
      : cardname = json['cardname'].toString(),
        cardicon = json['cardicon'].toString(),
        caption = json['caption'].toString(),
        text = json['text'].toString(),
        link = json['link'].toString(),
        id = json['id'].toString();

  Map<String, dynamic> toJson() => {
        'cardname': cardname,
        'cardicon': cardicon,
        'caption': caption,
        'text': text,
        'link': link,
        'id': id,
      };
}
