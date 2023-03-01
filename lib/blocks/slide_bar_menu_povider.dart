import 'package:flutter/cupertino.dart';

class MenuProvider extends ChangeNotifier {
  int _currentPage = 0;

  MenuProvider();

  int get currentPage => _currentPage;

  void updateCurrentPage(int index) {
    if (index != currentPage) {
      _currentPage = index;
      notifyListeners();
    }
  }
}
