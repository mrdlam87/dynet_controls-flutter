import 'package:flutter/material.dart';
import 'package:dynet_controls_v2/constants.dart';
import 'package:dynet_controls_v2/Components/search_bar.dart';

class TabSearchScrollView extends StatefulWidget {
  TabSearchScrollView({
    required this.children,
    required this.tabs,
    required this.length,
    this.tabIndex = 0,
    this.onChanged,
    this.showSearchBar = false,
    this.expandSearchBar = false,
    this.hintText,
    this.expandChild,
    this.leadingChild,
    this.trailingChild,
    this.onTabChanged,
    this.tabController,
  });

  final List<Widget> children;
  final List<Widget> tabs;
  final int length;
  int tabIndex;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  bool showSearchBar;
  bool expandSearchBar;
  final Widget? expandChild;
  final Widget? leadingChild;
  final Widget? trailingChild;
  final ValueChanged<int>? onTabChanged;
  final TabController? tabController;

  @override
  State<TabSearchScrollView> createState() => _TabSearchScrollViewState();
}

class _TabSearchScrollViewState extends State<TabSearchScrollView>
    with TickerProviderStateMixin {
  String query = '';
  // int _selectedIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: widget.length,
      vsync: this,
      initialIndex: widget.tabIndex,
    );

    _tabController.addListener(() {
      widget.tabIndex = _tabController.index;
      if (widget.onTabChanged != null) {
        widget.onTabChanged!(widget.tabIndex);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              elevation: widget.showSearchBar ? 0 : 10,
              floating: true,
              snap: true,
              automaticallyImplyLeading: false,
              forceElevated: innerBoxIsScrolled,
              backgroundColor: kBackgroundColour,
              toolbarHeight: widget.showSearchBar ? 40 : kToolbarHeight,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: widget.showSearchBar ? const EdgeInsets.symmetric(horizontal: 10) : null,
                title: TabBar(
                  controller: _tabController,
                  isScrollable: widget.length < 4 ? false : true,
                  labelColor: kItemColour,
                  unselectedLabelColor: kInactiveColour,
                  labelStyle: const TextStyle(fontSize: 15),
                  // labelPadding: EdgeInsets.only(left: 20, right: 20),
                  // indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                      color: kCardColour,
                      borderRadius: BorderRadius.circular(5)),
                  tabs: widget.tabs,
                ),
              ),
            ),
          )
        ];
      },
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              if (widget.showSearchBar)
                SearchBar(
                  expandSearchBar: widget.expandSearchBar,
                  expandSearchChild: widget.expandChild,
                  onChanged: (query) {
                    widget.tabIndex = _tabController.index;
                    this.query = query;
                    if (widget.onChanged != null) {
                      widget.onChanged!(query);
                    }
                  },
                  hintText: widget.hintText,
                  text: query,
                  leadingChild: widget.leadingChild,
                  trailingChild: widget.trailingChild,
                ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: widget.children,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                elevation: 10,
                backgroundColor: kMenuColour,
                child: const Icon(Icons.home, color: kItemColour),
                onPressed: () {
                  setState(() {
                    _tabController.animateTo(0);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
