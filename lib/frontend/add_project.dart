import 'package:flutter/material.dart';
import 'home_page.dart';
import '../backend/add_project_back.dart';
import 'alert_popups.dart';

Map<String, String> projectData = new Map(); //All data for the new project

class CreateProjectPage extends StatefulWidget {
  @override
  State createState() => new _CreateProjectPage();
}

class _CreateProjectPage extends State<CreateProjectPage>{

  //Text Controllers
  final projectName = new TextEditingController();
  final projectLocation = new TextEditingController();
  final projectClient = new TextEditingController();
  final projectType = new TextEditingController();
  final projectForeman = new TextEditingController();
  final projectBudget = new TextEditingController();
  final projectStartDate = new TextEditingController();
  final projectEndDate = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 140, 188, 63),
        title: Text("Add Project"),
        actions: <Widget>[
          Image.asset('assets/images/gcf_white.png'),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.centerLeft,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Name'),
            keyboardType: TextInputType.text,
            controller: projectName,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Location'),
            controller: projectLocation,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Client'),
            controller: projectClient,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Type'),
            controller: projectType,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Foreman'),
            controller: projectForeman,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Budget'),
            controller: projectBudget,
          ),
          TextField(
            decoration: InputDecoration(
                labelText: 'Project Start Date',
                hintText: 'DD/MM/YYYY',
                hintStyle: TextStyle(fontStyle: FontStyle.italic)),
                controller: projectStartDate,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project End Date'),
            controller: projectEndDate,
          ),
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
          projectData['projectName'] = projectName.text;
          projectData['projectLocation'] = projectLocation.text;
          projectData['projectClient'] = projectClient.text;
          projectData['projectType'] = projectType.text;
          projectData['projectForeman'] = projectForeman.text;
          projectData['projectBudget'] = projectBudget.text;
          projectData['projectStartDate'] = projectStartDate.text;
          projectData['projectEndDate'] = projectEndDate.text;


          _onItemTapped(context, index, projectName.text);
        },
      ),
    );
  }
}

void _onItemTapped(BuildContext context, int index, String name) {
  if (index == 0) {
    debugPrint('Cancel');
    Navigator.pop(
        context, MaterialPageRoute(builder: (context) => CreateProjectPage()));
  } else if (index == 1) {
    debugPrint('Create');
    debugPrint(name);
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

              if (project.processProjectData(projectData)){
                popUpInfo(context, "Success", "Project added successfully.");
              }else{
                popUpInfo(context, "Adding Error", "Failed to create project.\n" + 
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
