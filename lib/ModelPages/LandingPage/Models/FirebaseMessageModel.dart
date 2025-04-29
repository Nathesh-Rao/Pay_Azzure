class FirebaseMessageModel {
  String title;
  String body;

  FirebaseMessageModel.fromJson(Map<String, dynamic> json)
      : title = json['notify_title'].toString() ?? "",
        body = json['notify_body'].toString() ?? "";

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
      };

  FirebaseMessageModel(this.title, this.body);
}
