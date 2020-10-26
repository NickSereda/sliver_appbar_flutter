import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:sliver_appbar_flutter/search_bar_provider_data.dart';

//TODO: Desing of the SearchBar
//TODO: Implement Animation and Hide SearchButton(Maybe in CustomSliverDelegate itself)
class SearchBar extends StatelessWidget {

  final bool isSearching;

  SearchBar({@required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return
      // Stack(
      // alignment: Alignment.topRight,
      // children: [

        // AnimateExpansion(
        //         //   animate: !isSearching,
        //         //   axisAlignment: 1.0,
        //         //   child: Text('Dynamic AppBar Test'),
        //         // ),

        // Align(
        //   alignment: Alignment.topRight,
        //   child: Container(
        //           child: IconButton(
        //             icon: Icon(Icons.search),
        //             onPressed: (){
        //                     Provider.of<SearchBarData>(context, listen: false)
        //                         .toggleSelected();
        //             },
        //           ),
        //       ),
        // ),

        ///This Alignment ensures TextField slides from right and not from center
        Align(
          alignment: Alignment.topRight,
          child: AnimateExpansion(
            animate: isSearching,
            axisAlignment: -1.0,
            child: Container(
              ///same height as AppBar - 80
              height: 80,
                width: MediaQuery.of(context).size.width,
                ///positioning seachBar in the center
                // child: Center(child: Search())),
                child: Search()),
          ),
        );

    //   ],
    // );
  }
}
//TODO: Work on Design of the SearchBar
class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      decoration:
      InputDecoration(
         filled: true,
         fillColor: Colors.white,
        hintText: "Search", hintStyle: TextStyle(color: Colors.black26),
        prefixIcon: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.blue),onPressed: () {
          Provider.of<SearchBarData>(context, listen: false)
                        .toggleSelected();
        },),

        suffixIcon: IconButton(icon: Icon(Icons.search, color: Colors.blue),onPressed: () {
          Provider.of<SearchBarData>(context, listen: false)
              .toggleSelected();
         },),

        border: OutlineInputBorder(

          // borderRadius: BorderRadius.all(
          //   Radius.circular(20.0),
          // ),

          borderSide: BorderSide.none,

        ),

      ),
    );
  }
}

//TODO: Change Animation
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
  Animation<double> _animation;

  void prepareAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      // curve: Curves.linear,
      // reverseCurve: Curves.easeOut,
      curve: Curves.easeInCubic,
      reverseCurve: Curves.easeOutCubic,
    );
  }

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

