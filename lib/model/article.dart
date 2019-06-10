import 'package:oneminute/model/source.dart';

class Article {
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishDate;
  final String content;
  final Source source;


  Article(this.author, this.content, this.description, this.publishDate, this.title, this.url, this.urlToImage, this.source);

  Article.fromJson(Map<String, dynamic> json)
      : author = json["author"],
      title = json["title"] ?? "",
      description = json["description"] ?? "",
      url = json["url"],
      urlToImage = json["urlToImage"] ?? "",
      publishDate = json["publishedAt"],
      source = Source.fromJson(json["source"]),
      content = json["content"] ?? "";
}


