import 'dart:io';
import 'package:flutter/material.dart';
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

  @override
  _CustomScrollViewWithSliverAppBarState createState() =>
      _CustomScrollViewWithSliverAppBarState();
}

class _CustomScrollViewWithSliverAppBarState
    extends State<CustomScrollViewWithSliverAppBar> {

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          ///SliverPersistentHeader allows us to regulate expandedHeight dynamically with CustomSliverDelegate
          SearchBarSliverHeader(
            onQueryCallback: (String query) {
              print(query);
            },
            actions: [],
            title: Text("Title"),

            flexibleSpace: FlexibleSpaceBar.createSettings(currentExtent: 50, child:
            FlexibleSpaceBar(
              title: Text('FlexibleSpace'),
            ),
            ),

          ),

          ///Body of the screen
          SliverFillRemaining(
              child: Container(
                child: Text("TEST"),
                color: Theme.of(context).colorScheme.background,
              )
          )
        ],
      ),
    );
  }
}

class SearchBarSliverHeader extends StatelessWidget {

  final List<Widget> actions;

  final Widget title;

  final Widget leading;

  final Widget flexibleSpace;

  SearchCallback onQueryCallback;

  SearchBarSliverHeader({@required this.onQueryCallback, this.title, this.flexibleSpace, this.leading, @required this.actions});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return SearchBarData();
      },
      ///SliverPersistentHeader allows us to regulate expandedHeight dynamically with CustomSliverDelegate
      child: SliverPersistentHeader(
        ///To make the SliverAppBar expand / contract its content and prevent it from disappearing
        pinned: false,
        ///To make the content of the SliverAppBar appear / disappear when you scroll
        floating: true,
        delegate: CustomSliverDelegate(
          actions: actions,
          title: title,
          flexibleSpace: flexibleSpace,
          // FlexibleSpaceBar.createSettings(currentExtent: 50, child:
          // FlexibleSpaceBar(
          //   title: Text('FlexibleSpace'),
          // ),
          // ),
          leading: leading,
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
//not working
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    //TODO: Test if it works properly
    ///adding searchbar to actions
    if (!_IsSearchBarAdded) {
      actions.add(Visibility(
        visible: !Provider.of<SearchBarData>(context, listen: true).isSelected,
        child: IconButton(
          icon: Icon(Icons.search),
          onPressed: (){
            ///shows searchBar
            Provider.of<SearchBarData>(context, listen: false)
                .toggleSelected();

            ///Request Focus in searchBar
            focusNode.requestFocus();
            // FocusScope.of(context).requestFocus(focusNode);
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
            leading: leading,
            /// Searchbar functionality is implemeted on top of AppBar
            title: title,
            actions: actions,
            flexibleSpace: !Provider.of<SearchBarData>(context, listen: true).isSelected ? flexibleSpace : Container(),

          ),

          Column(
            children: [
              ///adjusted Value(Extent(97) - height(37) = SearchBar height(60))
              Container(height: 37),

              SearchBar(

                focusNode: focusNode,

                isSearching: Provider.of<SearchBarData>(context, listen: true).isSelected,
              //  onQueryChanged : onQueryCallback,
                  onQueryChanged: (String query) {
                  print("QUERY: $query");
                },
              ),


            ],
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
      return 97;
    }

  }

  @override
  double get minExtent => 97;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

}




