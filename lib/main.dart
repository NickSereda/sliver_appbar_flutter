import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sliver_appbar_flutter/post_model.dart';
import 'package:sliver_appbar_flutter/search_bar.dart';
import 'package:provider/provider.dart';
import 'package:sliver_appbar_flutter/search_bar_provider_data.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CustomScrollViewWithSliverAppBar(),
    );
  }
}


class CustomScrollViewWithSliverAppBar extends StatefulWidget {

  // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _CustomScrollViewWithSliverAppBarState createState() =>
      _CustomScrollViewWithSliverAppBarState();
}

class _CustomScrollViewWithSliverAppBarState
    extends State<CustomScrollViewWithSliverAppBar> {

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return SearchBarData();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            //TODO: FIX height of this Container
            ///Top color of SafeArea is Blue
            Container(
              height: 45,
            ///same as AppBar color
            color: Theme.of(context).colorScheme.primary),
            ///SafeArea ensures that SearchBar is in the safe area
            SafeArea(
              child: CustomScrollView(
              slivers: [
                ///SliverPersistentHeader allows us to regulate expandedHeight dynamically with CustomSliverDelegate
                SliverPersistentHeader(
                  ///To make the SliverAppBar expand / contract its content and prevent it from disappearing
                  pinned: false,
                  ///To make the content of the SliverAppBar appear / disappear when you scroll
                  floating: false,
                  delegate: CustomSliverDelegate(

                     actions: [
                          IconButton(
                           icon: Icon(Icons.handyman_sharp),
                           onPressed: () {

                           },
                           tooltip: 'Settings',
                         ),

                     ],
                    title: Text("Title"),
                    flexibleSpace: FlexibleSpaceBar.createSettings(currentExtent: 50, child:
                    FlexibleSpaceBar(
                      title: Text('FlexibleSpace'),
                    ),
                    ),
                     leading: FlutterLogo(),
                    //
                    // scaffoldKey: widget.scaffoldKey,
                  ),
                ),

                ///Body of the screen
                SliverFillRemaining(
                  //TODO: Add list of Items that uses searches for here
                  child: Container(
                    child: Text("TEST"),
                    color: Theme.of(context).colorScheme.background,
                  )
                )
              ],
          ),
            ),
          ],
        ),
      ),
    );
  }
}


typedef SearchCallback = void Function(String query);

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {

  final List<Widget> actions;

  final Widget title;

  final Widget leading;

  final Widget flexibleSpace;

  SearchCallback onQueryCallback;

bool _IsExpanded = false;

///So that we add searchbar only once
bool _IsSearchBarAdded = false;

CustomSliverDelegate({this.actions, this.title, this.leading, this.flexibleSpace, this.onQueryCallback});


@override
Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

  ///adding searchbar to actions
  if (!_IsSearchBarAdded) {
    actions.add(Visibility(
      visible: !Provider.of<SearchBarData>(context, listen: true).isSelected,
      child: IconButton(
        icon: Icon(Icons.search),
        onPressed: (){
          Provider.of<SearchBarData>(context, listen: false)
              .toggleSelected();

          ///TEST SearchCallback here


        },
      ),
    ),);
  }

  _IsSearchBarAdded = true;
  ///for toggling maxExtend
  _IsExpanded = Provider.of<SearchBarData>(context, listen: true).isSelected;

        return Container(
        child: Stack(
        children: [
          AppBar(
            leading: FlutterLogo(),
            /// Searchbar functionality is implemeted on top of AppBar
            title: title,
            actions: actions,
            flexibleSpace: !Provider.of<SearchBarData>(context, listen: true).isSelected ? flexibleSpace : Container(),

          ),

          Center(
              child: SearchBar(
                isSearching: Provider.of<SearchBarData>(context, listen: true).isSelected,
               // onQueryChanged : onQueryCallback,


                onSearchPressed: () {
                  print("Search Icon Pressed");
              },

                onEditingComplete: () {
                  print("Editing Complete");
                },

                onQueryChanged: (String query) {
                print("QUERY: $query");
              },

              )
          ),
        ],
        ),
      );

}

  //These overrides are required
  @override
  double get maxExtent {

  if (!_IsExpanded) {
    return 200;
  } else {
    return 60;
  }

  } // 200

  @override
  double get minExtent => 60; /// 60 same as SearchBar height

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

}



