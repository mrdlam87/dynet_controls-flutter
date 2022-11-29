import 'dart:io';
import 'package:dynet_controls_v2/screens/add_project_page.dart';
import 'package:dynet_controls_v2/screens/home_page.dart';

import '../providers/area_data.dart';
import '../providers/project_data.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  static const id = 'settings_page';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  File? projectFile;
  String? projectFileName;

  @override
  Widget build(BuildContext context) {
    final projectData = Provider.of<ProjectData>(context);
    final areaData = Provider.of<AreaData>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    String selectedProjectName = projectData.currentProjectName;

    SliverAppBar appBar = SliverAppBar(
      backgroundColor: kBackgroundColour,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: kItemColour,
          size: 15,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text('Settings', style: kCategoryStyle),
    );
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            appBar,
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  Container(
                    padding: const EdgeInsets.all(15),
                    height: screenHeight - 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(bottom: 25),
                                height: 35,
                                child: ProjectDropDownButton(
                                  onChange: (value) {
                                    selectedProjectName = value!;
                                  },
                                  projects: projectData.projects,
                                  currentValue: selectedProjectName,
                                ),
                              ),
                              Container(
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await projectData
                                        .selectProject(selectedProjectName);
                                    areaData.areaDataDecode(
                                        projectData.currentProject.areaData);
                                    areaData.updateGatewayAddress(projectData
                                        .currentProject.gatewayAddress);
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            HomePage.id, (route) => false);
                                  },
                                  child: const Text('Load Selected Project'),
                                  style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(10),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              kActiveButtonColour)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(AddProjectPage.id),
                            child: const Text('Add Project'),
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(10),
                                backgroundColor: MaterialStateProperty.all(
                                    kActiveButtonColour)),
                          ),
                        ),
                      ],
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

class ProjectDropDownButton extends StatefulWidget {
  ProjectDropDownButton({
    required this.projects,
    required this.currentValue,
    required this.onChange,
  });

  String currentValue;
  final List<Project> projects;
  final Function(String?)? onChange;

  @override
  State<ProjectDropDownButton> createState() => _ProjectDropDownButtonState();
}

class _ProjectDropDownButtonState extends State<ProjectDropDownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.currentValue,
      items: widget.projects
          .map((project) => DropdownMenuItem(
                child: Text(
                  project.projectName,
                  style: TextStyle(
                      color: project.projectName == widget.currentValue
                          ? null
                          : kInactiveColour),
                ),
                value: project.projectName,
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          widget.onChange!(value);
          widget.currentValue = value!;
        });
      },
      style: kPresetButtonStyle,
      dropdownColor: kBackgroundColour,
      decoration: kDropDownfieldDecoration.copyWith(
        labelText: 'Select Project',
      ),
      iconEnabledColor: kItemColour,
    );
  }
}
