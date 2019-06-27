import 'package:dio/dio.dart';
import 'package:oneminute/model/article_response.dart';

class ArticleApiProvider{
  final String _endpoint = "http://webcrawler.tugnetwork.mn/mapi/pages?web=60&sort=published,desc";
  final Dio _dio = Dio();

  Future<ArticleResponse> getArticle(int size) async {
    try {
      Response response = await _dio.get("http://webcrawler.tugnetwork.mn/mapi/pages?sort=published,desc&size=${size}");
      return ArticleResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ArticleResponse.withError("$error");
    }
  }
}