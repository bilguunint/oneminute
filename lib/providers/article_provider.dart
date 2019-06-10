import 'package:dio/dio.dart';
import 'package:oneminute/model/article_response.dart';

class ArticleApiProvider{
  final String _endpoint = "https://newsapi.org/v2/top-headlines?country=us&apiKey=3c8673ddff2f42eb81b5dfe63aec7be0";
  final Dio _dio = Dio();

  Future<ArticleResponse> getArticle() async {
    try {
      Response response = await _dio.get(_endpoint);
      return ArticleResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ArticleResponse.withError("$error");
    }
  }
}