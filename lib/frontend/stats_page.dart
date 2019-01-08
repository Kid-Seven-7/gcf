import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:gcf_projects_app/frontend/burger_menu_drawer.dart';
import 'package:gcf_projects_app/frontend/stats_widgets.dart';

var stat = 1;

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => new _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  _handleDrawer() {
    _key.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 140, 188, 63),
          title: stat == 0
              ? Text("Commercial Statistics")
              : stat == 1
              ? Text("Residential Statistics")
              : Text("All Statistics"),
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
          currentIndex: stat,
          fixedColor: Color.fromARGB(255, 140, 188, 63),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment), title: Text('Commercial')),
            BottomNavigationBarItem(
                icon: Icon(Icons.attach_money), title: Text('Residential')),
            BottomNavigationBarItem(
                icon: Icon(Icons.access_time), title: Text('All')),
          ],
          onTap: (index) {
            logNav(context, index);
          },
        ),
        drawer: OpenDrawer());
  }
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('log').snapshots(),
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

Widget buildNewCard(BuildContext context, DocumentSnapshot data) {
  Log log = Log.fromSnapshot(data);

  return Padding(
      key: ValueKey(log.projectName),
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      child: stat == 0
          ? commercialStatistics(context, log)
          : stat == 1
          ? residentialStatistics(context, log)
          : allStatistics(context, log)
  );
}

class Log {
  String projectName;
  String projectForeman;
  String projectDescription;
  String projectClient;
  String projectType;
  String projectLocation;
  String projectEndDate;
  String projectStartDate;
  String projectBudget;

  //TODO calculate time take cn
  DocumentReference reference;

  Log.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['projectName'] != null),
        assert(map['projectForeman'] != null),
        assert(map['projectDescription'] != null),
        assert(map['projectClient'] != null),
        assert(map['projectType'] != null),
        assert(map['projectLocation'] != null),
        assert(map['projectEndDate'] != null),
        assert(map['projectStartDate'] != null),
        assert(map['projectBudget'] != null),
        projectName = map['projectName'],
        projectForeman = map['projectForeman'],
        projectDescription = map['projectDescription'],
        projectClient = map['projectClient'],
        projectType = map['projectType'],
        projectLocation = map['projectLocation'],
        projectEndDate = map['projectEndDate'],
        projectStartDate = map['projectStartDate'],
        projectBudget = map['projectBudget'];

  Log.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}

void logNav(BuildContext context, int index) {
  if (index == 0) {
    if (stat != 0) {
      stat = 0;
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => StatsPage()));
    }
  } else if (index == 1) {
    if (stat != 1) {
      stat = 1;
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => StatsPage()));
    }
  } else if (index == 2) {
    if (stat != 2) {
      stat = 2;
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => StatsPage()));
    }
  }
}