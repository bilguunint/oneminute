import 'package:oneminute/model/article_response.dart';
import 'package:oneminute/providers/article_provider.dart';

class UserRepository{
  ArticleApiProvider _apiProvider = ArticleApiProvider();

  Future<ArticleResponse> getArticle(int size){
    return _apiProvider.getArticle(size);
  }
}