import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gcf_projects_app/frontend/add_project.dart';
import 'package:gcf_projects_app/frontend/project_view.dart';
import 'package:gcf_projects_app/frontend/burger_menu_drawer.dart';
import 'package:gcf_projects_app/backend/globals.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex_ = 0;

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  _handleDrawer() {
    _key.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    Firestore.instance.collection("notifications").getDocuments().then((value) {
      notifications = value.documents.length;
    }).catchError((onError) {});

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            key: _key,
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 140, 188, 63),
              title: Text("Dashboard"),
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: _handleDrawer,
              ),
              actions: <Widget>[
                Image.asset('assets/images/gcf_white.png'),
              ],
            ),
            body: _buildBody(context),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex_,
              fixedColor: Color.fromARGB(255, 140, 188, 63),
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    backgroundColor: Colors.black,
                    icon: Icon(Icons.rate_review),
                    title: Text('View Report')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.timeline), title: Text('View Statistics')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add), title: Text('Add project')),
              ],
              onTap: (index) {
                print("Index: $currentIndex_");
                onItemTapped(context, index);
                setState(() {
                  currentIndex_ = index;
                });
              },
            ),
            drawer: OpenDrawer()));
  }
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('activeProjects').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return LinearProgressIndicator();
      } else if (snapshot.hasError) {
        return LinearProgressIndicator();
      }

      return _buildList(context, snapshot.data.documents);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => buildNewCard(context, data)).toList(),
  );
}

void onItemTapped(BuildContext context, int index) {
  if (index == 0) {
  } else if (index == 1) {
  } else if (index == 2) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateProjectPage()));
  }
}

Widget buildNewCard(BuildContext context, DocumentSnapshot data) {
  Record record = Record.fromSnapshot(data);

  if ((record.projectForeman == userName) || (isAdmin == true)) {
    return Padding(
      key: ValueKey(record.projectName),
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      child: Container(
          child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text(
                record.projectName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(record.projectDescription),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Chip(
                  avatar: CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    child: Text('FM'),
                  ),
                  label: Text(record.projectForeman),
                ),
                ButtonTheme.bar(
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text(
                          'View project',
                          style: TextStyle(
                            color: Color.fromARGB(255, 140, 188, 63),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => ProjectCard(record)));
                          // _viewproject();
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      )),
    );
  } else {
    return Padding(
      padding: EdgeInsets.all(0),
    );
  }
}

class Record {
  String projectName,
      projectForeman,
      projectDescription,
      projectClient,
      projectStartDate,
      projectEndDate,
      projectType,
      projectLocation,
      projectBudget,
      projectTodo,
      projectID,
      projectExpenses;

  DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : projectName = map['projectName'],
        projectForeman = map['projectForeman'],
        projectDescription = map['projectDescription'],
        projectClient = map['projectClient'],
        projectStartDate = map['projectStartDate'],
        projectEndDate = map['projectEndDate'],
        projectType = map['projectType'],
        projectLocation = map['projectLocation'],
        projectBudget = map['projectBudget'],
        projectTodo = map['projectTodo'],
        projectID = map['projectID'],
        projectExpenses = map['projectExpenses'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
