import 'package:flutter/material.dart';

import 'add_project.dart';
import 'burger_menu_drawer.dart';
import 'project_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  _handleDrawer() {
    _key.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        backgroundColor: Colors.blueGrey.shade900,
        appBar: AppBar(
          backgroundColor: Colors.green.shade500,
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
            onItemTapped(context, index);
          },
        ),
        drawer: OpenDrawer());
  }
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('activeProjects').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

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
    debugPrint('View Report');
  } else if (index == 1) {
    debugPrint('View Statistics');
  } else if (index == 2) {
    debugPrint('Add project');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateProjectPage()));
  }
}

Widget buildNewCard(BuildContext context, DocumentSnapshot data) {
  Record record = Record.fromSnapshot(data);

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
                        Navigator.of(context).push(
                            new MaterialPageRoute(
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
}

class Record {
  String projectName;
  String projectForeman;
  String projectDescription;

  DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['projectName'] != null),
        assert(map['projectForeman'] != null),
        assert(map['projectDescription'] != null),
        projectName = map['projectName'],
        projectForeman = map['projectForeman'],
        projectDescription = map['projectDescription'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
