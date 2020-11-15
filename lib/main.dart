import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sliver_appbar_flutter/search_bar.dart';
import 'package:provider/provider.dart';
import 'package:sliver_appbar_flutter/search_bar_provider_data.dart';

import 'app_bar.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    print(change);
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(cubit, error, stackTrace);
  }
}

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppBarWithSearchBar(),
     //  home: CustomScrollViewWithSliverAppBar(),
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
          // SliverPersistentHeader allows us to regulate expandedHeight dynamically with CustomSliverDelegate
          SearchBarSliverHeader(
            onQueryCallback: (String query) {
              print(query);
            },
            elevation: 1,
            bottomOpacity: 0.7,
            automaticallyImplyLeading: false,
            excludeHeaderSemantics: true,
            // maxHeight: 300,
            actions: [],
            title: Text("Title"),
            flexibleSpace: FlexibleSpaceBar.createSettings(
              currentExtent: 50,
              child: FlexibleSpaceBar(
                title: Text('FlexibleSpace'),
              ),
            ),
          ),

          //Body of the screen
          SliverFillRemaining(
              child: Container(
            child: Text("TEST"),
            color: Theme.of(context).colorScheme.background,
          ))
        ],
      ),
    );
  }
}

/// Creates a sliver that varies its size when it is scrolled to the start of
/// a viewport.
class SearchBarSliverHeader extends StatelessWidget {
  /// Whether the title should be centered.
  ///
  /// If this property is null, then [AppBarTheme.centerTitle] of
  /// [ThemeData.appBarTheme] is used. If that is also null, then value is
  /// adapted to the current [TargetPlatform].
  final bool centerTitle;

  /// Whether the title should be wrapped with header [Semantics].
  ///
  /// Defaults to false.
  final bool excludeHeaderSemantics;

  /// Controls whether we should try to imply the leading widget if null.
  ///
  /// If true and [leading] is null, automatically try to deduce what the leading
  /// widget should be. If false and [leading] is null, leading space is given to [title].
  /// If leading widget is not null, this parameter has no effect.
  final bool automaticallyImplyLeading;

  /// The spacing around [title] content on the horizontal axis. This spacing is
  /// applied even if there is no [leading] content or [actions]. If you want
  /// [title] to take all the space available, set this value to 0.0.
  ///
  /// Defaults to [NavigationToolbar.kMiddleSpacing].
  final double titleSpacing;

  /// How opaque the toolbar part of the app bar is.
  ///
  /// A value of 1.0 is fully opaque, and a value of 0.0 is fully transparent.
  ///
  /// Typically, this value is not changed from its default value (1.0). It is
  /// used by [SearchBarSliverHeader] to animate the opacity of the toolbar when the app
  /// bar is scrolled.
  final double toolbarOpacity;

  /// How opaque the bottom part of the app bar is.
  ///
  /// A value of 1.0 is fully opaque, and a value of 0.0 is fully transparent.
  ///
  /// Typically, this value is not changed from its default value (1.0). It is
  /// used by [SearchBarSliverHeader] to animate the opacity of the toolbar when the app
  /// bar is scrolled.
  final double bottomOpacity;

  /// Defines the width of [leading] widget.
  ///
  /// By default, the value of `leadingWidth` is 56.0.
  final double leadingWidth;

  /// The z-coordinate at which to place this app bar relative to its parent.
  ///
  /// This controls the size of the shadow below the app bar.
  ///
  /// The value is non-negative.
  ///
  /// If this property is null, then [AppBarTheme.elevation] of
  /// [ThemeData.appBarTheme] is used. If that is also null, the default value
  /// is 4.
  final double elevation;

  /// The color to paint the shadow below the app bar.
  ///
  /// If this property is null, then [AppBarTheme.shadowColor] of
  /// [ThemeData.appBarTheme] is used. If that is also null, the default value
  /// is fully opaque black.
  final Color shadowColor;

  /// The color to use for the app bar's material. Typically this should be set
  /// along with [brightness], [iconTheme], [textTheme].
  ///
  /// If this property is null, then [AppBarTheme.color] of
  /// [ThemeData.appBarTheme] is used. If that is also null, then
  /// [ThemeData.primaryColor] is used.
  final Color backgroundColor;

  /// The brightness of the app bar's material. Typically this is set along
  /// with [backgroundColor], [iconTheme], [textTheme].
  ///
  /// If this property is null, then [AppBarTheme.brightness] of
  /// [ThemeData.appBarTheme] is used. If that is also null, then
  /// [ThemeData.primaryColorBrightness] is used.
  final Brightness brightness;

  /// The color, opacity, and size to use for app bar icons. Typically this
  /// is set along with [backgroundColor], [brightness], [textTheme].
  ///
  /// If this property is null, then [AppBarTheme.iconTheme] of
  /// [ThemeData.appBarTheme] is used. If that is also null, then
  /// [ThemeData.primaryIconTheme] is used.
  final IconThemeData iconTheme;

  /// The color, opacity, and size to use for the icons that appear in the app
  /// bar's [actions]. This should only be used when the [actions] should be
  /// themed differently than the icon that appears in the app bar's [leading]
  /// widget.
  ///
  /// If this property is null, then [AppBarTheme.actionsIconTheme] of
  /// [ThemeData.appBarTheme] is used. If that is also null, then this falls
  /// back to [iconTheme].
  final IconThemeData actionsIconTheme;

  /// The typographic styles to use for text in the app bar. Typically this is
  /// set along with [brightness] [backgroundColor], [iconTheme].
  ///
  /// If this property is null, then [AppBarTheme.textTheme] of
  /// [ThemeData.appBarTheme] is used. If that is also null, then
  /// [ThemeData.primaryTextTheme] is used.
  final TextTheme textTheme;

  /// The material's shape as well its shadow.
  ///
  /// A shadow is only displayed if the [elevation] is greater than
  /// zero.
  final ShapeBorder shape;

  /// This widget appears across the bottom of the app bar.
  ///
  /// Typically a [TabBar]. Only widgets that implement [PreferredSizeWidget] can
  /// be used at the bottom of an app bar.
  ///
  /// See also:
  ///
  ///  * [PreferredSize], which can be used to give an arbitrary widget a preferred size.
  final PreferredSizeWidget bottom;

  /// The [actions] become the trailing component of the [NavigationToolbar] built
  /// by this widget. The height of each action is constrained to be no bigger
  /// than the [toolbarHeight].
  final List<Widget> actions;

  /// The primary widget displayed in the app bar.
  ///
  /// Typically a [Text] widget that contains a description of the current
  /// contents of the app.
  ///
  /// Becomes the middle component of the [NavigationToolbar] built by this widget.
  /// The [title]'s width is constrained to fit within the remaining space
  /// between the toolbar's [leading] and [actions] widgets. Its height is
  /// _not_ constrained. The [title] is vertically centered and clipped to fit
  /// within the toolbar, whose height is [toolbarHeight]. Typically this
  /// isn't noticeable because a simple [Text] [title] will fit within the
  /// toolbar by default. On the other hand, it is noticeable when a
  /// widget with an intrinsic height that is greater than [toolbarHeight]
  /// is used as the [title]. For example, when the height of an Image used
  /// as the [title] exceeds [toolbarHeight], it will be centered and
  /// clipped (top and bottom), which may be undesirable.
  final Widget title;

  /// A widget to display before the [title].
  ///
  /// Typically the [leading] widget is an [Icon] or an [IconButton].
  ///
  /// Becomes the leading component of the [NavigationToolbar] built
  /// by this widget. The [leading] widget's width and height are constrained to
  /// be no bigger than [leadingWidth] and [toolbarHeight] respectively.
  ///
  /// If this is null and [automaticallyImplyLeading] is set to true, the
  /// [AppBar] will imply an appropriate widget. For example, if the [AppBar] is
  /// in a [Scaffold] that also has a [Drawer], the [Scaffold] will fill this
  /// widget with an [IconButton] that opens the drawer (using [Icons.menu]). If
  /// there's no [Drawer] and the parent [Navigator] can go back, the [AppBar]
  /// will use a [BackButton] that calls [Navigator.maybePop].
  final Widget leading;

  /// This widget is stacked behind the toolbar and the tab bar. Its height will
  /// be the same as the app bar's overall height.
  /// Typically a [FlexibleSpaceBar]. See [FlexibleSpaceBar] for details.
  final Widget flexibleSpace;

  /// Height of this Widget when expanded. By default, the value of `maxHeight` is 200.0.
  final double maxHeight;

  /// This callback is used in [SearchBar] of this Widget.
  SearchCallback onQueryCallback;

  SearchBarSliverHeader({
    @required this.actions,
    this.maxHeight,
    this.title,
    this.leading,
    this.flexibleSpace,
    this.onQueryCallback,
    this.bottom,
    this.centerTitle,
    this.excludeHeaderSemantics,
    this.automaticallyImplyLeading,
    this.titleSpacing,
    this.toolbarOpacity,
    this.bottomOpacity,
    this.leadingWidth,
    this.elevation,
    this.shadowColor,
    this.backgroundColor,
    this.brightness,
    this.iconTheme,
    this.actionsIconTheme,
    this.textTheme,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return SearchBarData();
      },
      // SliverPersistentHeader allows us to regulate expandedHeight dynamically with CustomSliverDelegate
      child: SliverPersistentHeader(
        // To make the SliverAppBar expand / contract its content and prevent it from disappearing
        pinned: false,
        // To make the content of the SliverAppBar appear / disappear when you scroll
        floating: true,
        delegate: CustomSliverDelegate(
          maxHeight: maxHeight,
          automaticallyImplyLeading: automaticallyImplyLeading,
          centerTitle: centerTitle,
          excludeHeaderSemantics: excludeHeaderSemantics,
          titleSpacing: titleSpacing,
          toolbarOpacity: toolbarOpacity,
          bottomOpacity: bottomOpacity,
          leadingWidth: leadingWidth,
          elevation: elevation,
          shadowColor: shadowColor,
          backgroundColor: backgroundColor,
          brightness: brightness,
          iconTheme: iconTheme,
          actionsIconTheme: actionsIconTheme,
          textTheme: textTheme,
          shape: shape,
          bottom: bottom,
          actions: actions,
          title: title,
          flexibleSpace: flexibleSpace,
          leading: leading,
        ),
      ),
    );
  }
}

typedef SearchCallback = void Function(String query);

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double maxHeight;
  final bool centerTitle;
  final bool excludeHeaderSemantics;
  final bool automaticallyImplyLeading;
  final double titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double leadingWidth;
  final double elevation;
  final Color shadowColor;
  final Color backgroundColor;
  final Brightness brightness;
  final IconThemeData iconTheme;
  final IconThemeData actionsIconTheme;
  final TextTheme textTheme;
  final ShapeBorder shape;
  final PreferredSizeWidget bottom;
  final List<Widget> actions;
  final Widget title;
  final Widget leading;
  final Widget flexibleSpace;

  SearchCallback onQueryCallback;

  CustomSliverDelegate({
    this.maxHeight,
    this.actions,
    this.title,
    this.leading,
    this.flexibleSpace,
    this.onQueryCallback,
    this.bottom,
    this.centerTitle,
    this.excludeHeaderSemantics,
    this.automaticallyImplyLeading,
    this.titleSpacing,
    this.toolbarOpacity,
    this.bottomOpacity,
    this.leadingWidth,
    this.elevation,
    this.shadowColor,
    this.backgroundColor,
    this.brightness,
    this.iconTheme,
    this.actionsIconTheme,
    this.textTheme,
    this.shape,
  });

  FocusNode focusNode = FocusNode();

  bool _IsExpanded = false;

  double _appBarHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    //calculating appBar height when collapsed
    _appBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;

    //_IsExpanded is used for toggling maxExtend
    _IsExpanded = Provider.of<SearchBarData>(context, listen: true).isSelected;

    return Container(
      child: Stack(
        children: [
          AppBar(
            automaticallyImplyLeading: automaticallyImplyLeading ?? true,
            // Primary not Working with our Widget
            centerTitle: centerTitle,
            excludeHeaderSemantics: excludeHeaderSemantics ?? false,
            titleSpacing: titleSpacing ?? NavigationToolbar.kMiddleSpacing,
            toolbarOpacity: toolbarOpacity ?? 1.0,
            bottomOpacity: bottomOpacity ?? 1.0,
            leadingWidth: leadingWidth,
            elevation: elevation,
            shadowColor: shadowColor,
            backgroundColor: backgroundColor,
            brightness: brightness,
            iconTheme: iconTheme,
            actionsIconTheme: actionsIconTheme,
            textTheme: textTheme,
            shape: shape,
            bottom: bottom,
            leading: leading,
            // Searchbar functionality is implemeted on top of AppBar
            title: title,
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  //shows searchBar
                  Provider.of<SearchBarData>(context, listen: false)
                      .toggleSelected();
                  //Request Focus in searchBar
                  focusNode.requestFocus();
                },
              ),
            ]..addAll(actions),

            flexibleSpace: flexibleSpace,
          ),
          Column(
            children: [
              // In Android phones top padding seems to be smaller and searchbar does not appear at bottom
              Container(height: MediaQuery.of(context).padding.top - 1),
              SearchBar(
                focusNode: focusNode,
                isSearching: Provider.of<SearchBarData>(context, listen: true)
                    .isSelected,
                onQueryChanged: onQueryCallback,
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
      return maxHeight ?? 200;
    } else {
      return _appBarHeight;
    }
  }

  @override
  double get minExtent => _appBarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
