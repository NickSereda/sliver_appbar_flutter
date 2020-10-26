import 'dart:io';

import 'package:flutter/material.dart';

import 'package:sliver_appbar_flutter/search_bar.dart';

import 'package:provider/provider.dart';
import 'package:sliver_appbar_flutter/search_bar_provider_data.dart';
import 'package:sliver_appbar_flutter/sprung_search_bar.dart';

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
        body: Stack(
          children: [
            //TODO: FIX height of this Container
            ///Top color of SafeArea is Blue
            Container(
              height: 45,
            color: Colors.blue,),
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

                    // scaffoldKey: widget.scaffoldKey,
                  ),
                ),

                ///Body of the screen
                SliverFillRemaining(
                  //TODO: Add list of Items that uses searches for here
                  child: Center(
                    child: Container(
                      color: Colors.white24,
                    ),
                  ),
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


class CustomSliverDelegate extends SliverPersistentHeaderDelegate {


  //TODO: Implement and add this method to SearchBarData
  void handleClick(String value, BuildContext context) {

  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

   final appBarHeight = Provider.of<SearchBarData>(context, listen: true).appBarHeight;

//TODO: appBar height should be a little bigger then searchbar height
    ///
      return Container(

        height: appBarHeight,

        child: Stack(
          children: [

            AppBar(

              leading: FlutterLogo(),

              /// Searchbar functionality is implemeted in title
              // title: Center(
              //     child: SearchBar(
              //       isSearching:
              //       Provider.of<SearchBarData>(context, listen: true).isSelected,
              //     )
              // ),

              actions: [
                //

                  Visibility(
                    visible: !Provider.of<SearchBarData>(context, listen: true).isSelected,
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: (){
                        Provider.of<SearchBarData>(context, listen: false)
                            .toggleSelected();
                      },
                    ),
                  ),
                  Visibility(
                    visible: !Provider.of<SearchBarData>(context, listen: true).isSelected,
                    child: IconButton(
                      icon: Icon(Icons.handyman_sharp),
                      onPressed: () {

                      },
                      tooltip: 'Search',
                    ),
                  ),

              ],
              //TODO: Find out about Purpose of currentExtent?
              flexibleSpace: !Provider.of<SearchBarData>(context, listen: true).isSelected ? FlexibleSpaceBar.createSettings(currentExtent: 50, child:

              FlexibleSpaceBar(

                title: Text('FlexibleSpace'),


              ),

              ): Container(),
            ),

            Center(
                child: SearchBar(
                  isSearching:
                  Provider.of<SearchBarData>(context, listen: true).isSelected,
                )
            ),

          ],

        ),
      );
    }


  //These overrides are required
  @override
  double get maxExtent => 200;

  @override
  double get minExtent => 60; ///kToolbarHeight == 56.0

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

}

