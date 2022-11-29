import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../providers/area_data.dart';
import '../providers/project_data.dart';
import '../screens/loading_page.dart';
import '../constants.dart';

class AddProjectPage extends StatefulWidget {
  static const id = 'add_project_page';

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  File? projectFile;
  String? projectFileName;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Future _openFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      projectFile = File(result.files.first.path!);
      setState(() {
        projectFileName = result.files.first.name;
      });
    }
  }

  Future _addProject() async {
    final projectData = Provider.of<ProjectData>(context, listen: false);
    final areaData = Provider.of<AreaData>(context, listen: false);

    try {
      await areaData.loadXmlFile(projectFile!);
      await projectData.addProject(
        name: _nameController.text,
        address: _addressController.text,
        areaData: areaData.areaDataEncoded,
      );

      areaData.updateGatewayAddress(projectData.currentProject.gatewayAddress);
      Navigator.of(context).pushNamed(LoadingPage.id);
    } catch (error) {
      _showErrorSnackBar('Could not add project.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        elevation: 10,
        margin: const EdgeInsets.all(10),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        action: SnackBarAction(
            label: 'DISMISS',
            textColor: kActiveButtonColour,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    SliverAppBar appBar = SliverAppBar(
      backgroundColor: kBackgroundColour,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: kItemColour,
          size: 15,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: const Text('Add Project', style: kCategoryStyle),
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
                                child: TextField(
                                  style: kPresetButtonStyle,
                                  cursorColor: kItemColour,
                                  decoration: kTextfieldDecoration.copyWith(
                                      labelText: 'Project Name'),
                                  controller: _nameController,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 25),
                                height: 35,
                                child: TextField(
                                  style: kPresetButtonStyle,
                                  cursorColor: kItemColour,
                                  keyboardType: TextInputType.number,
                                  decoration: kTextfieldDecoration.copyWith(
                                      labelText: 'Gateway Address'),
                                  controller: _addressController,
                                ),
                              ),
                              if (projectFile != null)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 25),
                                  height: 35,
                                  child: TextField(
                                    style: kPresetButtonStyle,
                                    cursorColor: kItemColour,
                                    keyboardType: TextInputType.number,
                                    decoration: kTextfieldDecoration.copyWith(
                                        labelText: 'XML File'),
                                    readOnly: true,
                                    controller: TextEditingController()
                                      ..text = projectFileName!,
                                  ),
                                ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 25),
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: _openFile,
                                  child: const Text('Open XML File'),
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
                            onPressed: _addProject,
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
