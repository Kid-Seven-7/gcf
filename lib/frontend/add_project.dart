import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:gcf_projects_app/backend/add_project_back.dart';
import 'package:gcf_projects_app/frontend/home_page.dart';
import 'package:gcf_projects_app/frontend/alert_popups.dart';

Map<String, String> projectData = new Map(); //All data for the new project

//This list is for the project type
List<DropdownMenuItem<String>> projectTypeItems = [
  new DropdownMenuItem(
    value: "Project Type...",
    child: Text(
      "Project Type...",
    ),
  ),
  new DropdownMenuItem(
    value: "Residential",
    child: Text("Residential"),
  ),
  new DropdownMenuItem(
    value: "Business",
    child: Text("Business"),
  ),
];

List<DropdownMenuItem<String>> projectFormanItems = [
  new DropdownMenuItem(
    value: "Project Forman...",
    child: Text("Project Forman..."),
  ),
];

String currentForman = "Project Forman...";
String currentProjectType = "Project Type...";

class CreateProjectPage extends StatefulWidget {
  @override
  State createState() => new _CreateProjectPage();
}

class _CreateProjectPage extends State<CreateProjectPage> {
  //Text Controllers
  final projectName = new TextEditingController();
  final projectDescription = new TextEditingController();
  final projectLocation = new TextEditingController();
  final projectClient = new TextEditingController();
  final projectBudget = new TextEditingController();
  String projectForeman;
  String projectType;

  //Date picker variables
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy");
  DateTime date;
  String projectStartDate;
  String projectEndDate;

  //Project creation variables
  bool projectCreated = false;

  @override
  Widget build(BuildContext context) {
    Firestore.instance
        .collection("users")
        .reference()
        .where("role", isEqualTo: "Foreman")
        .getDocuments()
        .then((data) {
      for (var doc in data.documents) {
        String name = doc['name'];
        bool nameExists = false;

        if (name != null) {
          DropdownMenuItem item = new DropdownMenuItem<String>(
            value: name,
            child: Text(name),
          );

          projectFormanItems.forEach((data) {
            if (data.value != null && data.value == name) {
              nameExists = true;
            }
          });

          if (!nameExists) {
            projectFormanItems.add(item);
            nameExists = false;
          }
        }
      }
    }).catchError((onError){
      popUpInfo(context, "Error", "Unable to connect to the database.\n Error Code: 7URHFHD" );
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 140, 188, 63),
        title: Text("Add Project"),
        actions: <Widget>[
          Image.asset('assets/images/gcf_white.png'),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Name'),
            keyboardType: TextInputType.text,
            controller: projectName,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Description'),
            keyboardType: TextInputType.text,
            controller: projectDescription,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Location'),
            controller: projectLocation,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Client'),
            controller: projectClient,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          DropdownButton(
            isExpanded: true,
            value: currentProjectType,
            items: projectTypeItems,
            onChanged: (type) {
              setState(() {
                currentProjectType = type;
                if (currentProjectType != "Project Type...") {
                  projectType = currentProjectType;
                }
              });
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          DropdownButton(
            isExpanded: true,
            value: currentForman,
            items: projectFormanItems,
            onChanged: (forman) {
              setState(() {
                currentForman = forman;
                if (currentForman != "Project Forman...") {
                  projectForeman = currentForman;
                }
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Budget'),
            keyboardType: TextInputType.number,
            controller: projectBudget,
          ),
          DateTimePickerFormField(
              format: dateFormat,
              decoration: InputDecoration(labelText: 'Project Start Date'),
              onChanged: (dt) {
                setState(() {
                  date = dt;
                  projectStartDate = date.toString().substring(0, 11);
                });
              }),
          DateTimePickerFormField(
              format: dateFormat,
              decoration: InputDecoration(labelText: 'Project End Date'),
              onChanged: (dt) {
                setState(() {
                  date = dt;
                  projectEndDate = date.toString().substring(0, 11);
                });
              }),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Color.fromARGB(255, 140, 188, 63),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(Icons.cancel),
              title: Text('Cancel')),
          BottomNavigationBarItem(
              icon: Icon(Icons.check), title: Text('Create')),
        ],
        onTap: (index) {
          //Populate the map
          var projectID = new Uuid();

          projectData['projectName'] = projectName.text;
          projectData['projectDescription'] = projectDescription.text;
          projectData['projectLocation'] = projectLocation.text;
          projectData['projectClient'] = projectClient.text;
          projectData['projectType'] = projectType;
          projectData['projectForeman'] = projectForeman;
          projectData['projectBudget'] = projectBudget.text;
          projectData['projectStartDate'] = projectStartDate;
          projectData['projectEndDate'] = projectEndDate;
          projectData['projectTodo'] = ",";
          projectData['projectID'] = projectID.v1();
          projectData['projectExpenses'] = "0";
          currentProjectType = "Project Type...";
          _onItemTapped(context, index, projectName.text);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

void _onItemTapped(BuildContext context, int index, String name) {
  if (index == 0) {
    Navigator.pop(
        context, MaterialPageRoute(builder: (context) => CreateProjectPage()));
  } else if (index == 1) {
    _newproject(context, name);
  }
}

Future<void> _newproject(BuildContext context, String name) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Create Project'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to create\n$name?'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              //Add data to the database

              Project project = new Project();

              print(projectData);
              Navigator.of(context).pop();

              if (project.processProjectData(projectData)) {
                popUpInfo(context, "Success", "Project added successfully.");
              } else {
                popUpInfo(
                    context,
                    "Adding Error",
                    "Failed to create project.\n" +
                        "Reason: Some fields are empty");
              }
              // Navigator.pop(context,
              // MaterialPageRoute(builder: (context) => CreateProjectPage()));
            },
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () {
              projectData.clear();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
