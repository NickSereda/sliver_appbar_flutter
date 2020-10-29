import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/search_bar_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';


@immutable
abstract class SearchBarState {
  const SearchBarState();
}

class SearchBarInitial extends SearchBarState {
  const SearchBarInitial();
}

//class SearchBar