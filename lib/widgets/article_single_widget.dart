import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:oneminute/blocs/article_bloc.dart';
import 'package:oneminute/model/article.dart';
import 'package:oneminute/model/article_response.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:oneminute/widgets/article_story_widget.dart';
import 'package:oneminute/widgets/detail_article.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:html/parser.dart' show parse;
import 'package:oneminute/style/theme.dart' as Style;


class ArticleSingleWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ArticleSingleWidgetState();
  }
}

class _ArticleSingleWidgetState extends State<ArticleSingleWidget> {
  int size = 10;
  PageController pageController =
      PageController(viewportFraction: 1, keepPage: true);
  @override
  void initState() {
    super.initState();
    size = 10;
    pageController = PageController()..addListener(_listener);
    articleBloc.getArticle(size);
  }
  _listener() {
    if(pageController.page > size-10){
      setState(() {
        size = size + 20;
      });
      articleBloc.getArticle(size+20);
    }
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
    return Column(
      children: <Widget>[
        Container(
                height: 100,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                
                  itemCount: articles.length,
                  itemBuilder: (context, index) {

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ArticleStoryWidget()));
                      },
                      child: Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 10.0),
                      child: 
                      Column(
                        children: <Widget>[
                           Container(
             width: 60.0,
             height: 60.0,
             child: Container(
               decoration: BoxDecoration(
                 borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                 border: Border.all(
                 color: Colors.white,
                 
                 width: 3.0,
               )
               ),
             ),
             decoration: new BoxDecoration(
               color: const Color(0xff7c94b6),
               image: new DecorationImage(
                 image: new NetworkImage("${articles[index].picture}"),
                 fit: BoxFit.cover,
               ),
               borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
               border: new Border.all(
                 color: Colors.grey[400],
                 width: 1.5,
               ),
             ),
           ),
           SizedBox(
             height: 5.0,
           ),
           Text(
             articles[index].source.domain.length > 12
                            ? articles[index].source.domain.substring(0, 9) +
                                "..."
                            : articles[index].source.domain
            , style: TextStyle(
             color: Colors.black,
             fontWeight: FontWeight.bold,
             fontSize: 9
           ),)
                        ],
                      )
                     
                    )
                    );
                  },
                ),
              ),
          Container(
            height: MediaQuery.of(context).size.height-230,
            child: RefreshIndicator(
              onRefresh: _refreshNews,
              child: PageView.builder(
      controller: pageController,
      scrollDirection: Axis.vertical,
      itemCount: articles.length,
      itemBuilder: (context, index) {
        print(articles[index].category);
        if(index.isOdd) {
          return Container(
          child: 
              Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 1 / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FadeInImage.assetNetwork(
                        alignment: Alignment.topCenter,
                        placeholder: 'images/placeholder.png',
                        image: articles[index].picture == null 
                        ?
                        "http://to-let.com.bd/operator/images/noimage.png"
                        :
                        articles[index].picture
                        ,
                        fit: BoxFit.cover,
                        width: double.maxFinite,
                        height:  MediaQuery.of(context).size.height*1/3
                      ),
                  ],
                ),
              ),
              Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 2 / 3-230,
                              child:  Container(
                padding: EdgeInsets.all(10.0),
                child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(articles[index].source.domain, style: TextStyle(
                          color: Style.Colors.mainColor,
                          fontWeight: FontWeight.bold
                        )),
                        Row(
                            children: <Widget>[
                              Icon(EvaIcons.heartOutline,
                              size: 20.0,
                              color: Colors.black,
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Icon(EvaIcons.bookmarkOutline,
                              size: 20.0,
                              color: Colors.black,
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Icon(EvaIcons.moreVerticalOutline,
                              size: 20.0,
                              color: Colors.black,
                              ),
                              
                            ],
                          ),
                        
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                        GestureDetector(
                      onTap: () {
                        
                      },
                      child: Text(
                          articles[index].title.length > 60
                            ? articles[index].title.substring(0, 55) + "..."
                            : articles[index].title,
                          maxLines: 2,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20.0)),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(timeUntil(DateTime.parse(articles[index].source.date)), style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0
                        ),),   
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(_parseHtmlString(articles[index].text),
                      maxLines: 3,
                      style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      height: 1.2
                    ),),
                  ],
                ),
              ),
                            ),
             
            ],
          ),
         
            
          );
        } else {
          return Container(
          child: Column(
            children: <Widget>[
              Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 1 / 3,
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
                        height: MediaQuery.of(context).size.height * 1 / 3  ),
                  ],
                ),
              ),
              Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 1 / 3,
                              decoration: BoxDecoration(
                                  
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      stops: [
                                        0.1,
                                        1
                                      ],
                                      colors: [
                                        Colors.black.withOpacity(0.8),
                                        Colors.white.withOpacity(0.0)
                                      ])),
                              alignment: Alignment.bottomLeft,
                              child:  Container(
                padding: EdgeInsets.all(15.0),
                child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          height: 10.0,
                        ),
                        GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailArticle(article: articles[index])));
                      },
                      child: Text(
                          articles[index].title.length > 45
                              ? articles[index].title.substring(0, 45) + "..."
                              : articles[index].title,
                          style: TextStyle(
                              fontFamily: "MontBold",
                              color: Colors.white,
                              fontSize: 20.0)),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Row(
                      children: <Widget>[
                        Text(timeUntil(DateTime.parse(articles[index].source.date)), style: TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0
                        ),),
                       
                      ],
                    ),
                         Row(
                            children: <Widget>[
                              Icon(EvaIcons.heartOutline,
                              size: 20.0,
                              color: Colors.white,
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Icon(EvaIcons.bookmarkOutline,
                              size: 20.0,
                              color: Colors.white,
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Icon(EvaIcons.moreVerticalOutline,
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
          Container(
            height: 164,
            width: MediaQuery.of(context).size.width,
            child: Padding(
                  padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    children: <Widget>[
                      Container(
                        height: 196,
                        
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: FadeInImage.assetNetwork(
                        alignment: Alignment.topCenter,
                        placeholder: 'images/placeholder.png',
                        image: articles[index+6].picture == null
                            ? "http://to-let.com.bd/operator/images/noimage.png"
                            : articles[index+6].picture,
                        fit: BoxFit.cover,
                        width: double.maxFinite,
                        height: 100 )
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child:  Text(
                          articles[index+6].title.length > 40
                              ? articles[index+6].title.substring(0, 40) + "..."
                              : articles[index+6].title,
                              maxLines: 2,
                          style: TextStyle(
                              fontFamily: "RubikBold",
                              color: Colors.black,
                              fontSize: 12.0))
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                          Text(timeUntil(DateTime.parse(articles[index+6].source.date)), style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0
                        ),),
                             
                          ],
                        ),
                      ),
                      Container(
                        height: 196,
                       
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: FadeInImage.assetNetwork(
                        alignment: Alignment.topCenter,
                        placeholder: 'images/placeholder.png',
                        image: articles[index+8].picture == null
                            ? "http://to-let.com.bd/operator/images/noimage.png"
                            : articles[index+8].picture,
                        fit: BoxFit.cover,
                        width: double.maxFinite,
                        height: 100 )
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child:  Text(
                          articles[index+8].title.length > 40
                              ? articles[index+8].title.substring(0, 40) + "..."
                              : articles[index+8].title,
                          maxLines: 2,
                          style: TextStyle(
                              fontFamily: "RubikBold",
                              color: Colors.black,
                              fontSize: 12.0))
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                          Text(timeUntil(DateTime.parse(articles[index+8].source.date)), style: TextStyle(
                          color: Colors.black54, 
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0
                        ),),
                             
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          )
            ],
          )
          
        );
        }
        
      },
    )
            )
            
          )
         
      ],
    );
   
  }
  Future<void> _refreshNews() async
  {
    print('refreshing stocks...');
    articleBloc.getArticle(size);
  }
  String timeUntil(DateTime date) {
  return timeago.format(date, allowFromNow: true);
}
String _parseHtmlString(String htmlString) {

var document = parse(htmlString);

String parsedString = parse(document.body.text).documentElement.text;

return parsedString;
}
}
