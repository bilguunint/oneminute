import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oneminute/model/article.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart' show parse;
import 'package:timeago/timeago.dart' as timeago;
import 'package:oneminute/style/theme.dart' as Style;

class DetailArticle extends StatefulWidget {
  final Article article;
  DetailArticle({Key key, @required this.article}) : super(key: key);
  @override
  _DetailArticleState createState() => _DetailArticleState(article);
}

class _DetailArticleState extends State<DetailArticle> {
  final Article article;
  _DetailArticleState(this.article);
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black45, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          article.title,
          style: TextStyle(color: Colors.black45, fontSize: 16.0),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height-80,
          child: 
              ListView(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 1 / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FadeInImage.assetNetwork(
                        alignment: Alignment.topCenter,
                        placeholder: 'images/placeholder.png',
                        image: article.picture == null 
                        ?
                        "http://to-let.com.bd/operator/images/noimage.png"
                        :
                        article.picture
                        ,
                        fit: BoxFit.cover,
                        width: double.maxFinite,
                        height:  MediaQuery.of(context).size.height*1/3
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                     SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(article.source.domain, style: TextStyle(
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
                         article.title,
                       
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20.0)),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(timeUntil(DateTime.parse(article.source.date)), style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0
                        ),),   
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(_parseHtmlString(article.text),
                      
                      style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      height: 1.2
                    ),),
                  ],
                ),
              )
                   
                  ],
                ),
              ),
                            
           
         
            
          
        ],
      ),
    );
  }
  String _parseHtmlString(String htmlString) {

var document = parse(htmlString);

String parsedString = parse(document.body.text).documentElement.text;

return parsedString;
}
String timeUntil(DateTime date) {
  return timeago.format(date, allowFromNow: true);
}
}
