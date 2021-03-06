import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:sliver_appbar_flutter/main.dart';
import 'package:sliver_appbar_flutter/search_bar_provider_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/searchbar_cubit.dart';
import 'cubit/searchbar_state.dart';

class TEST extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class SearchBar extends StatelessWidget {

  final bool isSearching;

  final SearchCallback onQueryChanged;

  final FocusNode focusNode;

  SearchBar({this.isSearching, this.onQueryChanged , this.focusNode});

  @override
  Widget build(BuildContext context) {
    //This Alignment ensures TextField slides from right and not from center
    return Align(
      alignment: Alignment.topRight,
      child: AnimateExpansion(
        animate: isSearching,
        axisAlignment: -1.0,
        child: Container(
          // height: 60,
          height: kToolbarHeight,
            width: MediaQuery.of(context).size.width,
            child: Search(onQueryChanged: onQueryChanged, focusNode: focusNode)),
      ),
    );
  }
}

class Search extends StatefulWidget {

  final SearchCallback onQueryChanged;

  final FocusNode focusNode;

  Search({@required this.onQueryChanged, this.focusNode});

  @override
  _SearchState createState() => _SearchState();

}

class _SearchState extends State<Search>  {

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    widget.focusNode.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBarCubit, SearchBarState>(
          builder: (context, state) {
    // final bloc = SearchBarProvider.of(context);

      // return StreamBuilder<bool>(
      //   stream: bloc.selectedBool,
      //   builder: (context, snapshot) {

          // if (snapshot.data == null) {
          //   bloc.changeSelected(false);
          // }

          return TextField(

            controller: _controller,

            focusNode: widget.focusNode,

            autofocus: false,

            onChanged: widget.onQueryChanged,

            onEditingComplete: () {
              _controller.clear();

              context.read<SearchBarCubit>().toggleSelected();

              widget.focusNode.unfocus();
            },

            decoration:
            InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.black26),
              prefixIcon: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.blue),

                onPressed: () {
                  _controller.clear();

                  widget.focusNode.unfocus();

                  context.read<SearchBarCubit>().toggleSelected();

                },

              ),

              suffixIcon: IconButton(icon: Icon(Icons.search, color: Colors.blue),

                onPressed: () {
                  _controller.clear();

                  context.read<SearchBarCubit>().toggleSelected();

                  widget.focusNode.unfocus();

                },

              ),

              border: OutlineInputBorder(

                borderSide: BorderSide.none,

              ),
            ),
          );
        }
      );

  }
}

///Animation
class AnimateExpansion extends StatefulWidget {
  final Widget child;
  final bool animate;
  final double axisAlignment;
  AnimateExpansion({
    this.animate = false,
    this.axisAlignment,
    this.child,
  });

  @override
  _AnimateExpansionState createState() => _AnimateExpansionState();
}

class _AnimateExpansionState extends State<AnimateExpansion>
    with SingleTickerProviderStateMixin {

  AnimationController _animationController;

  ///Animation object allows us to pick CurvedAnimation behaviour
  Animation<double> _animation;

  void prepareAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      ///parent is AnimationController
      parent: _animationController,

      ///Choose CurvedAnimation behaviour here
      // curve: Curves.elasticOut,
      // reverseCurve: Curves.elasticOut,

      curve: Curves.ease,
      reverseCurve: Curves.ease,

      //  curve: Curves.easeInCubic,
      // reverseCurve: Curves.easeOutCubic,
    );
  }

  ///appear and hide when this method is called(in didUpdateWidget)
  void _toggle() {
    if (widget.animate) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _toggle();
  }

  @override
  void didUpdateWidget(AnimateExpansion oldWidget) {
    super.didUpdateWidget(oldWidget);
    _toggle();
  }

  ///Transition
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      // axis: Axis.vertical,
        axis: Axis.horizontal,
        axisAlignment: -1.0,
        sizeFactor: _animation,
        child: widget.child);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

