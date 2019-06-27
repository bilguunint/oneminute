import 'package:oneminute/model/category.dart';
import 'package:oneminute/model/source.dart';

class Article {
  final int id;
  final String title;
  final String published;
  final String picture;
  final String url;
  final String text;
  final Source source;
  final Category category;


  Article(this.id, this.picture, this.text, this.title, this.url, this.source, this.published, this.category);

  Article.fromJson(Map<String, dynamic> json)
      : id = json["id"],
      title = json["title"] ?? "",
      picture = json["picture"] ?? "",
      url = json["url"],
      source = Source.fromJson(json["web"]),
      published = json["published"] ?? "",
      category = json["category"] ?? Category.fromJson(json["web"]),
      text = json["text"] ?? "";
}


