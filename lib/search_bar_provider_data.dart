import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SearchBarData extends ChangeNotifier {

  bool isSelected = false;

  void toggleSelected() {

    isSelected = !isSelected;

    notifyListeners();

  }

}

