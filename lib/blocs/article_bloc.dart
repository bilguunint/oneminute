import 'package:oneminute/model/article_response.dart';
import 'package:oneminute/providers/article_repository.dart';
import 'package:rxdart/rxdart.dart';

class ArticleBloc {
  final UserRepository _repository = UserRepository();
  final BehaviorSubject<ArticleResponse> _subject =
      BehaviorSubject<ArticleResponse>();

  getArticle(int size) async {
    ArticleResponse response = await _repository.getArticle(size);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<ArticleResponse> get subject => _subject;
  
}
final articleBloc = ArticleBloc();