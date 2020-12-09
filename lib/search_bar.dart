import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:sliver_appbar_flutter/main.dart';
import 'package:sliver_appbar_flutter/search_bar_provider_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/searchbar_cubit.dart';
import 'cubit/searchbar_state.dart';

class TestTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}

class SearchBar extends StatelessWidget {
  final bool isSearching;

  final SearchCallback onQueryChanged;

  final FocusNode focusNode;

  SearchBar({this.isSearching, this.onQueryChanged, this.focusNode});

  @override
  Widget build(BuildContext context) {
    // This Alignment ensures TextField slides from right and not from center
    return Align(
      alignment: Alignment.topRight,
      child: AnimateExpansion(
        animate: isSearching,
        axisAlignment: -1.0,
        child: Container(
          // height: 60,
            width: MediaQuery.of(context).size.width,
            child: SearchTextField(
                onQueryChanged: onQueryChanged, focusNode: focusNode)),
      ),
    );
  }
}

class SearchTextField extends StatefulWidget {
  final SearchCallback onQueryChanged;

  final FocusNode focusNode;

  SearchTextField({@required this.onQueryChanged, this.focusNode});

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    widget.focusNode.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      // Setting to false because onChanged it works when SearchBar is hidden
      autofocus: false,
      onChanged: widget.onQueryChanged,
      onEditingComplete: () {
        _controller.clear();
        Provider.of<SearchBarData>(context, listen: false).toggleSelected();
        // Unfocusing textField(SearchBar)
        widget.focusNode.unfocus();
      },

      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.background,
        hintText: "Search",
        hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7)),
        prefixIcon: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.primary),
          onPressed: () {
            _controller.clear();
            Provider.of<SearchBarData>(context, listen: false).toggleSelected();
            widget.focusNode.unfocus();
          },
        ),
        suffixIcon: IconButton(
          icon:
          Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
          onPressed: () {
            _controller.clear();
            Provider.of<SearchBarData>(context, listen: false).toggleSelected();
            widget.focusNode.unfocus();
          },
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// Animation for the SearchBar
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

  // Animation object allows us to pick CurvedAnimation behaviour
  Animation<double> _animation;

  void prepareAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      // Parent is AnimationController
      parent: _animationController,
      // Choose CurvedAnimation behaviour in curve and reverseCurve:
      curve: Curves.ease,
      reverseCurve: Curves.ease,
    );
  }

  // SearchBar appear and hide when this method is called(in didUpdateWidget)
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

  // Transition
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
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
