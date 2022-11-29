import '../Services/db_helper.dart';
import '../models/project_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Project {
  final String projectName;
  final String gatewayAddress;
  final String areaData;

  Project({
    required this.projectName,
    required this.gatewayAddress,
    required this.areaData,
  });
}

class ProjectData with ChangeNotifier {
  String? _currentProjectName;

  List<Project> _projects = [];

  String get currentProjectName {
    return _currentProjectName!;
  }

  Project get currentProject {
    return _projects
        .firstWhere((project) => project.projectName == currentProjectName);
  }

  List<Project> get projects {
    return [..._projects];
  }

  Future addProject({
    required String name,
    required String address,
    required String areaData,
  }) async {
    if (!_projects.any((project) => project.projectName == name)) {
      final prefs = await SharedPreferences.getInstance();
      final newProject = Project(
          projectName: name, gatewayAddress: address, areaData: areaData);
      _projects.add(newProject);
      _currentProjectName = name;
      prefs.setString('currentProjectName', _currentProjectName!);
      DBHelper.insert(
        'projects',
        {
          'projectName': newProject.projectName,
          'gatewayAddress': newProject.gatewayAddress,
          'areaData': newProject.areaData,
        },
      );
    } else {
      throw ProjectException('Could not add project.');
    }
  }

  Future fetchAndSetProjects() async {
    final dataList = await DBHelper.getData('projects');
    final prefs = await SharedPreferences.getInstance();

    _projects = dataList
        .map((project) => Project(
              projectName: project['projectName'],
              gatewayAddress: project['gatewayAddress'],
              areaData: project['areaData'],
            ))
        .toList();

    _currentProjectName =
        prefs.getString('currentProjectName') ?? _projects.last.projectName;
  }

  Future selectProject(String projectName) async {
    final prefs = await SharedPreferences.getInstance();

    _currentProjectName = projectName;
    prefs.setString('currentProjectName', _currentProjectName!);
    notifyListeners();
  }
}
