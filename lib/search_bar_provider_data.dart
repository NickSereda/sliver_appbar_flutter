

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:sliver_appbar_flutter/post_model.dart';

//TODO: Rename SearchBarData to SliverAppBarData
//TODO: Change to Bloc pattern?

class SearchBarData extends ChangeNotifier {

  double get appBarHeight {

    //TODO: Replace hardcoded values with variables
    /// in order to increase 150, one needs to increase Max extend: now is set to 150!!!)
    ///
   return isSelected == false ? 200 : 60;

  }


  bool isSelected = false;


  void toggleSelected() {

    isSelected = !isSelected;

    notifyListeners();

}


}