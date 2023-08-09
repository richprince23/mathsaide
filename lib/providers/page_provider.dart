import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier {
  int _pageIndex = 0;

  /// Returns current page index
  get pageIndex => _pageIndex;

  /// Sets a new page index
  void setPage(int index) {
    _pageIndex = index;
    notifyListeners();
  }
}
