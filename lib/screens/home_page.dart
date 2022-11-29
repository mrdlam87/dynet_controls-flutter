import 'package:dynet_controls_v2/screens/settings_page.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../Components/tab_search_scroll_view.dart';
import '../Components/narrow_text_button.dart';
import '../Components/small_text_button.dart';
import 'overview_page.dart';
import '../screens/preset_page.dart';
import '../providers/area_data.dart';
import '../models/area.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String id = 'main_tab_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool gridView = true;
  int gridSize = 2;
  bool showSearchBar = true;
  bool expandSearchBar = false;
  String query = '';
  int currentTabIndex = 0;
  late List<List<Area>> currentAreaCollection;
  late List<Area> currentAreaList;
  late AnimationController _animationController;

  List<Widget> buildAllTabs() {
    final areaData = Provider.of<AreaData>(context, listen: false);

    List<Widget> allTabs = [
      CustomTab(label: 'Overview'),
    ];

    allTabs.addAll(
      areaData.folders.map(
        (folder) => CustomTab(label: folder.folderName),
      ),
    );

    return allTabs;
  }

  void searchPresetCards(String query) {
    final areaData = Provider.of<AreaData>(context, listen: false);
    final areaLists = areaData.allAreaLists.map((areas) {
      return areas.where((area) {
        final areaNameLower = area.areaName.toLowerCase();
        final queryLower = query.toLowerCase();

        return areaNameLower.contains(queryLower);
      }).toList();
    }).toList();

    setState(() {
      currentAreaCollection = areaLists;
    });
  }

  @override
  void initState() {
    final areaData = Provider.of<AreaData>(context, listen: false);
    currentAreaList = areaData.allAreaLists[0];
    currentAreaCollection = areaData.allAreaLists;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final expandBar = Row(
      children: <Widget>[
        NarrowTextButton(
          label: 'Expanded',
          state: !gridView,
          onPress: () {
            setState(() {
              gridView = false;
            });
          },
        ),
        NarrowTextButton(
          label: 'Grid',
          state: gridView,
          onPress: () {
            setState(() {
              gridView = true;
            });
          },
        ),
        if (gridView)
          Row(
            children: <Widget>[
              NarrowTextButton(
                label: 'Grid Size:',
              ),
              SmallTextButton(
                label: '2',
                state: gridSize == 2,
                onPress: () {
                  setState(() {
                    gridSize = 2;
                  });
                },
              ),
              SmallTextButton(
                label: '3',
                state: gridSize == 3,
                onPress: () {
                  setState(() {
                    gridSize = 3;
                  });
                },
              ),
              SmallTextButton(
                label: '4',
                state: gridSize == 4,
                onPress: () {
                  setState(() {
                    gridSize = 4;
                  });
                },
              ),
            ],
          ),
      ],
    );
    return Scaffold(
      body: SafeArea(
        child: TabSearchScrollView(
          hintText: 'Enter search',
          showSearchBar: showSearchBar,
          expandSearchBar: expandSearchBar,
          expandChild: Row(
            children: <Widget>[
              expandBar,
            ],
          ),
          leadingChild: IconButton(
            splashRadius: 20,
            icon: const Icon(
              Icons.menu,
              color: kItemColour,
            ),
            onPressed: () async {
              await Navigator.of(context).pushNamed(SettingsPage.id);
                final areaData = Provider.of<AreaData>(context, listen: false);
                currentAreaList = areaData.allAreaLists[0];
                currentAreaCollection = areaData.allAreaLists;
            },
          ),
          trailingChild: IconButton(
            splashRadius: 20,
            onPressed: () {
              setState(() {
                expandSearchBar = !expandSearchBar;
              });
            },
            icon: Icon(
              expandSearchBar ? Icons.expand_less : Icons.expand_more,
              color: kInactiveColour,
              size: 30,
            ),
          ),
          children: <Widget>[
            OverviewPage(
              areaList: currentAreaList,
              gridView: gridView,
              gridSize: gridSize,
            ),
            ...currentAreaCollection
                .map(
                  (areaList) => PresetPage(
                    areaList: areaList,
                    gridView: gridView,
                    gridSize: gridSize,
                  ),
                )
                .toList(),
          ],
          length: buildAllTabs().length,
          tabs: buildAllTabs(),
          onChanged: (query) {
            searchPresetCards(query);
          },
        ),
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  CustomTab({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: Tab(
        child: Text(label),
      ),
    );
  }
}
