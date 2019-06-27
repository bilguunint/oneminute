import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oneminute/blocs/article_bloc.dart';
import 'package:oneminute/model/article.dart';
import 'package:oneminute/model/article_response.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:oneminute/widgets/detail_article.dart';
import 'package:quiver/async.dart';
import 'package:timeago/timeago.dart' as timeago;

class ArticleStoryWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ArticleStoryWidgetState();
  }
}

class _ArticleStoryWidgetState extends State<ArticleStoryWidget> {
  int _start = 5;
  int size = 10;
  int _current = 10;
  int _page = 2;

  PageController controller =
      PageController(viewportFraction: 1, keepPage: true);
  var currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    CountdownTimer countDownTimer = new CountdownTimer(
    new Duration(seconds: _start),
    new Duration(seconds: 1),
  );

  var sub = countDownTimer.listen(null);
  sub.onData((duration) {
    setState(() { _current = _start - duration.elapsed.inSeconds; });
  });

  sub.onDone(() {
    Timer.periodic(new Duration(seconds: 5), (timer) {
   controller.jumpToPage(_page++);
});
    controller.jumpToPage(_page++);
    sub.cancel();
  });
   
    articleBloc.getArticle(size);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
      stream: articleBloc.subject.stream,
      builder: (context, AsyncSnapshot<ArticleResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return Scaffold(body: _buildErrorWidget(snapshot.data.error));
          }
          return Scaffold(
              body: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: <Widget>[
                      _buildArticleWidget(snapshot.data),
                      Padding(
                        padding: EdgeInsets.only(top: 40.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              EvaIcons.arrowBack,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      
                      Padding(
                          padding:
                              EdgeInsets.only(top: 30, left: 10.0, right: 10.0),
                          child: Container(
                            height: 3.0,
                            child: ProgressIndicatorDemo(),
                          ))
                    ],
                  )));
        } else if (snapshot.hasError) {
          return Scaffold(body: _buildErrorWidget(snapshot.error));
        } else {
          return Scaffold(body: _buildLoadingWidget());
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
    return Container(
        height: MediaQuery.of(context).size.height,
        child: RefreshIndicator(
            onRefresh: _refreshNews,
            child: PageView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return Container(
                    child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              FadeInImage.assetNetwork(
                                  alignment: Alignment.topCenter,
                                  placeholder: 'images/placeholder.png',
                                  image: articles[index].picture == null
                                      ? "http://to-let.com.bd/operator/images/noimage.png"
                                      : articles[index].picture,
                                  fit: BoxFit.cover,
                                  width: double.maxFinite,
                                  height: MediaQuery.of(context).size.height),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  stops: [
                                0.1,
                                0.9
                              ],
                                  colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.white.withOpacity(0.0)
                              ])),
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(articles[index].source.domain,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0)),
                                )),
                                SizedBox(
                                  height: 5.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailArticle(
                                                article: articles[index])));
                                  },
                                  child: Text(articles[index].title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 25.0)),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          timeUntil(DateTime.parse(
                                              articles[index].source.date)),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          EvaIcons.heartOutline,
                                          size: 20.0,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        Icon(
                                          EvaIcons.bookmarkOutline,
                                          size: 20.0,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        Icon(
                                          EvaIcons.moreVerticalOutline,
                                          size: 20.0,
                                          color: Colors.white,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ));
              },
            )));
  }

  Future<void> _refreshNews() async {
    print('refreshing stocks...');
    articleBloc.getArticle(size);
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true);
  }
}

class ProgressIndicatorDemo extends StatefulWidget {
  @override
  _ProgressIndicatorDemoState createState() =>
      new _ProgressIndicatorDemoState();
}

class _ProgressIndicatorDemoState extends State<ProgressIndicatorDemo>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this)
      ..addListener(() {
        setState(() {});
      });
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.black.withOpacity(0.5),
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      value: animation.value,
    );
  }
}
