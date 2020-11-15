import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sliver_appbar_flutter/cubit/searchbar_state.dart';

class SearchBarCubit extends Cubit<SearchBarState> {
  SearchBarCubit() : super(SearchBarState());

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //
  // GlobalKey get scaffoldKey {
  //   return _scaffoldKey;
  // }


  bool toggleSelected() {
    if (state.isSelected == false) {
      emit(SearchBarState(isSelected: true));
    } else {
      emit(SearchBarState(isSelected: false));
    }

  }




}