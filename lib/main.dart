import 'package:dynet_controls_v2/Services/custom_route.dart';
import 'package:dynet_controls_v2/constants.dart';
import 'package:dynet_controls_v2/providers/project_data.dart';
import 'package:dynet_controls_v2/screens/add_project_page.dart';
import 'package:dynet_controls_v2/screens/home_page.dart';
import 'package:dynet_controls_v2/screens/new_project_page.dart';
import 'package:dynet_controls_v2/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'screens/loading_page.dart';
import 'package:dynet_controls_v2/providers/area_data.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(DynetApp());
}

class DynetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProjectData>(create: (ctx) => ProjectData()),
        ChangeNotifierProvider<AreaData>(create: (ctx) => AreaData()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Lato',
          scaffoldBackgroundColor: kBackgroundColour,
          pageTransitionsTheme: PageTransitionsTheme(
                    builders: {
                      TargetPlatform.android: CustomPageTransitionBuilder(),
                    }
                  )
        ),
        initialRoute: LoadingPage.id,
        routes: {
          LoadingPage.id: (context) => LoadingPage(),
          HomePage.id:(context) => HomePage(),
          NewProjectsPage.id:(context) => NewProjectsPage(),
          SettingsPage.id:(context) => SettingsPage(),
          AddProjectPage.id:(context) => AddProjectPage(),
        },
      ),
    );
  }
}