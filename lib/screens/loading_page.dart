import 'package:dynet_controls_v2/screens/home_page.dart';
import 'package:dynet_controls_v2/screens/new_project_page.dart';
import '../providers/project_data.dart';
import '../providers/area_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constants.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatefulWidget {
  static const id = 'loading_page';

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Future loadProject() async {
    final projectData = Provider.of<ProjectData>(context, listen: false);
    final areaData = Provider.of<AreaData>(context, listen: false);

    try {
      await projectData.fetchAndSetProjects();
      areaData.areaDataDecode(projectData.currentProject.areaData);
      areaData.updateGatewayAddress(projectData.currentProject.gatewayAddress);
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.of(context).pushReplacementNamed(HomePage.id);
    } catch (error) {
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.of(context).pushReplacementNamed(NewProjectsPage.id);
    }
  }

  @override
  void initState() {
    loadProject();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: kItemColour,
          size: 100.0,
        ),
      ),
    );
  }
}
