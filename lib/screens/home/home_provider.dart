import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier{
  int selectedIndex = 0;
  
  updateSelectedIndex(int index){
    selectedIndex=index;
    notifyListeners();
  }
}