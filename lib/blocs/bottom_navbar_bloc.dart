import 'dart:async';

enum NavBarItem { MENU, TOPIC, ARTICLE, NOTIFICATION, SAVED }

class BottomNavBarBloc {
  final StreamController<NavBarItem> _navBarController =
      StreamController<NavBarItem>.broadcast();

  NavBarItem defaultItem = NavBarItem.ARTICLE;

  Stream<NavBarItem> get itemStream => _navBarController.stream;

  void pickItem(int i) {
    switch (i) {
      case 0:
        _navBarController.sink.add(NavBarItem.MENU);
        break;
      case 1:
        _navBarController.sink.add(NavBarItem.TOPIC);
        break;
      case 2:
        _navBarController.sink.add(NavBarItem.ARTICLE);
        break;
        case 3:
        _navBarController.sink.add(NavBarItem.NOTIFICATION);
        break;
        case 4:
        _navBarController.sink.add(NavBarItem.SAVED);
        break;
    }
  }

  close() {
    _navBarController?.close();
  }
}