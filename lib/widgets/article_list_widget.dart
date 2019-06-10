import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oneminute/blocs/article_bloc.dart';
import 'package:oneminute/model/article.dart';
import 'package:oneminute/model/article_response.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:oneminute/style/theme.dart' as Style;

class ArticleListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ArticleListWidgetState();
  }
}

class _ArticleListWidgetState extends State<ArticleListWidget> {
  @override
  void initState() {
    super.initState();
    articleBloc.getArticle();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
      stream: articleBloc.subject.stream,
      builder: (context, AsyncSnapshot<ArticleResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return _buildErrorWidget(snapshot.data.error);
          }
          return _buildArticleWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.black45),
              strokeWidth: 2.0,
            ))
      ],
    ));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error"),
      ],
    ));
  }

  Widget _buildArticleWidget(ArticleResponse data) {
    List<Article> articles = data.results;
    print(articles);
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.grey[200], width: 1.0),),
                  color: Colors.white,
                ),
          
          height: 150,
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
                width: MediaQuery.of(context).size.width * 3 / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(articles[index].source.name,
                        style: TextStyle(
                            color: Style.Colors.mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0)),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                        articles[index].title.length > 60
                            ? articles[index].title.substring(0, 55) + "..."
                            : articles[index].title,
                            maxLines: 3,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16.0)),
                    Expanded(
                        child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(articles[index].publishDate.substring(0, 10),
                                  style: TextStyle(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0)),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                  articles[index].publishDate.substring(11, 16),
                                  style: TextStyle(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(EvaIcons.heartOutline,
                              size: 20.0,
                              color: Colors.black,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Icon(EvaIcons.bookmarkOutline,
                              size: 20.0,
                              color: Colors.black,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Icon(EvaIcons.moreVerticalOutline,
                              size: 20.0,
                              color: Colors.black,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                            ],
                          )
                        ],
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 10.0),
                width: MediaQuery.of(context).size.width*2/5,
                height: 130,
                child: FadeInImage.assetNetwork(
                        alignment: Alignment.topCenter,
                        placeholder: 'images/placeholder.png',
                        image: articles[index].urlToImage == null 
                        ?
                        "http://to-let.com.bd/operator/images/noimage.png"
                        :
                        articles[index].urlToImage
                        ,
                        fit: BoxFit.fitHeight,
                        width: double.maxFinite,
                        height:  MediaQuery.of(context).size.height*1/3
                      )
              )
            ],
          ),
        );
      },
    );
  }
}
