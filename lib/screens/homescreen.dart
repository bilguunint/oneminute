import 'package:flutter/material.dart';
import 'package:oneminute/blocs/bottom_navbar_bloc.dart';
import 'package:oneminute/blocs/switch_bloc.dart';
import 'package:oneminute/widgets/article_list_widget.dart';
import 'package:oneminute/widgets/article_single_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:oneminute/style/theme.dart' as Style;

class HomeScreen extends StatefulWidget {
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BottomNavBarBloc _bottomNavBarBloc;
  SwitchBloc _switchBloc;
  void _showSingle() {
    print("Single Clicked");
    _switchBloc.showSingle();
  }

  void _showList() {
    print("List Clicked");
    _switchBloc.showList();
  }

  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBarBloc();
    _switchBloc = SwitchBloc();
  }

  @override
  void dispose() {
    _bottomNavBarBloc.close();
    _switchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: new Text(
            "eagle",
            style: TextStyle(
                fontSize: Theme.of(context).platform == TargetPlatform.iOS
                    ? 20.0
                    : 24.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                EvaIcons.searchOutline,
              ),
              color: Colors.black,
             
              onPressed: () {},
            ),
            StreamBuilder<NavBarItem>(
              stream: _bottomNavBarBloc.itemStream,
              initialData: _bottomNavBarBloc.defaultItem,
              builder:
                  (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
                switch (snapshot.data) {
                  case NavBarItem.MENU:
                    return Container();
                  case NavBarItem.TOPIC:
                    return Container();
                  case NavBarItem.ARTICLE:
                    return StreamBuilder<SwitchItem>(
                      stream: _switchBloc.itemStream,
                      initialData: _switchBloc.defaultItem,
                      builder: (BuildContext context,
                          AsyncSnapshot<SwitchItem> snapshot) {
                        switch (snapshot.data) {
                          case SwitchItem.LIST:
                            return IconButton(
                                icon: Icon(EvaIcons.fileTextOutline),
                                color: Colors.black,
                              
                                onPressed: _showSingle);
                          case SwitchItem.SINGLE:
                            return IconButton(
                                icon: Icon(EvaIcons.listOutline),
                                color: Colors.black,
                           
                                onPressed: _showList);
                        }
                      },
                    );

                  case NavBarItem.NOTIFICATION:
                    return Container();
                  case NavBarItem.SAVED:
                    return Container();
                }
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<NavBarItem>(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          switch (snapshot.data) {
            case NavBarItem.MENU:
              return _alertArea();
            case NavBarItem.TOPIC:
              return _alertArea();
            case NavBarItem.ARTICLE:
              return StreamBuilder<SwitchItem>(
                stream: _switchBloc.itemStream,
                initialData: _switchBloc.defaultItem,
                builder:
                    (BuildContext context, AsyncSnapshot<SwitchItem> snapshot) {
                  switch (snapshot.data) {
                    case SwitchItem.LIST:
                      return ArticleListWidget();
                    case SwitchItem.SINGLE:
                      return ArticleSingleWidget();
                  }
                },
              );
            case NavBarItem.NOTIFICATION:
              return _settingsArea();
            case NavBarItem.SAVED:
              return _settingsArea();
          }
        },
      ),
      bottomNavigationBar: StreamBuilder(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            fixedColor: Style.Colors.mainColor,
            currentIndex: snapshot.data.index,
            onTap: _bottomNavBarBloc.pickItem,
            items: [
              BottomNavigationBarItem(
                  title: Text('Menu', style: TextStyle(fontSize: 0)),
                  icon: Icon(EvaIcons.menu2Outline),
                  activeIcon: Icon(EvaIcons.menu2)),
              BottomNavigationBarItem(
                  title: Text('Topic', style: TextStyle(fontSize: 0)),
                  icon: Icon(EvaIcons.gridOutline),
                  activeIcon: Icon(EvaIcons.grid)),
              BottomNavigationBarItem(
                  title: Text('Articles', style: TextStyle(fontSize: 0)),
                  icon: Icon(EvaIcons.fileTextOutline),
                  activeIcon: Icon(EvaIcons.fileText)),
              BottomNavigationBarItem(
                  title: Text('Notification', style: TextStyle(fontSize: 0)),
                  icon: Icon(EvaIcons.bellOutline),
                  activeIcon: Icon(EvaIcons.bell)),
              BottomNavigationBarItem(
                  title: Text('Saved', style: TextStyle(fontSize: 0)),
                  icon: Icon(EvaIcons.bookmarkOutline),
                  activeIcon: Icon(EvaIcons.bookmark)),
            ],
          );
        },
      ),
    );
  }

  Widget _alertArea() {
    return Center(
      child: Text(
        'Test Screen',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.red,
          fontSize: 25.0,
        ),
      ),
    );
  }

  Widget _settingsArea() {
    return Center(
      child: Text(
        'Test Screen',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.blue,
          fontSize: 25.0,
        ),
      ),
    );
  }
}
