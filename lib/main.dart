
import 'package:flutter/material.dart';
import 'package:oneminute/screens/homescreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "MontReg",
        iconTheme: IconThemeData(
            color: Colors.black45, 
          ),
        textTheme: TextTheme(
        title: TextStyle(fontSize: 30, color: Colors.black45),
        subtitle: TextStyle(fontSize: 20, color: Colors.black45),
        body1: TextStyle(fontSize: 15, color: Colors.black45)),
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

