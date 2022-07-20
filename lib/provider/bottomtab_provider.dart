import 'package:flutter/cupertino.dart';

class BottomTabProvider extends ChangeNotifier{
  //タイプを選択後、変数に選択したタイプの数字を入力するメソッド
  int _currentIndex = 2;

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}