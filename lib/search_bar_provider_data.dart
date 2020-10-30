

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';



class SearchBarData extends ChangeNotifier {

  double get appBarHeight {

    /// in order to increase 200, one needs to increase Max extend also
    return isSelected == false ? 200 : 97;

  }

  bool isSelected = false;

  void toggleSelected() {

    isSelected = !isSelected;

    notifyListeners();

  }

  ///Text Field Focusing
//common instance of focus node
//   FocusNode focusNode = FocusNode();
//
//
//   void requestFocus() {
//
//     focusNode.requestFocus(focusNode);
//
//    // notifyListeners();
//
//   }
//
//
//   void disposeFocusNode() {
//
//     focusNode.dispose();
//
//     //notifyListeners();
//
//   }
//
//   void unfocusFocusNode() {
//     focusNode.unfocus();
//
//     //notifyListeners();
//
//   }


}