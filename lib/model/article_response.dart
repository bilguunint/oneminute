import 'package:oneminute/model/article.dart';

class ArticleResponse {
  final List<Article> results;
  final String error;

  ArticleResponse(this.results, this.error);

  ArticleResponse.fromJson(Map<String, dynamic> json)
      : results =
            (json["articles"] as List).map((i) => new Article.fromJson(i)).toList(),
        error = "";

  ArticleResponse.withError(String errorValue)
      : results = List(),
        error = errorValue;
}