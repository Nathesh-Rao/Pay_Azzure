/// title : "Daily Quotes !"
/// description : "Great things happen to those who don't stop believing, trying, learning, and being grateful."
/// image : "../images/homepageicon/slider2.jpg"
/// link : ""

class BannerModel {
  BannerModel({
    this.title,
    this.description,
    this.image,
    this.link,
  });

  BannerModel.fromJson(dynamic json, String baseUrl) {
    title = json['title'];
    description = json['description'];
    image = baseUrl + json['image'].replaceFirst("../", "");
    link = json['link'];
  }

  String? title;
  String? description;
  String? image;
  String? link;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['description'] = description;
    map['image'] = image;
    map['link'] = link;
    return map;
  }
}
