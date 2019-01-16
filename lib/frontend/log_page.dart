import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:gcf_projects_app/frontend/burger_menu_drawer.dart';
import 'package:gcf_projects_app/frontend/log_widgets.dart';
import 'package:gcf_projects_app/backend/globals.dart';

var stat = 1;

/*
  Parameter:

  Function:

  Return:

*/
class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() => new _LogPageState();
}

/*
  Parameter:

  Function:

  Return:

*/
class _LogPageState extends State<LogPage> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  _handleDrawer() {
    _key.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        backgroundColor: gcfBG,
        appBar: AppBar(
          backgroundColor: gcfGreen,
          title: stat == 0
              ? Text("General Information")
              : stat == 1
              ? Text("Budget Information")
              : Text("Time Information"),
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
          fixedColor: gcfGreen,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment), title: Text('General')),
            BottomNavigationBarItem(
                icon: Icon(Icons.attach_money), title: Text('Budget')),
            BottomNavigationBarItem(
                icon: Icon(Icons.access_time), title: Text('Time')),
          ],
          onTap: (index) {
            logNav(context, index);
          },
        ),
        drawer: OpenDrawer());
  }
}

/*
  Parameter:

  Function:

  Return:

*/
Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('log').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.documents);
    },
  );
}

/*
  Parameter:

  Function:

  Return:

*/
Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => buildNewCard(context, data)).toList(),
  );
}

/*
  Parameter:

  Function:

  Return:

*/
Widget buildNewCard(BuildContext context, DocumentSnapshot data) {
  Log log = Log.fromSnapshot(data);

  return Padding(
      key: ValueKey(log.projectName),
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      child: stat == 0
          ? generalInfo(context, log)
          : stat == 1
          ? budgetInfo(context, log)
          : timeInfo(context, log)
  );
}

/*
  Parameter:

  Function:

  Return:

*/
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

/*
  Parameter:

  Function:

  Return:

*/
void logNav(BuildContext context, int index) {
  if (index == 0) {
    if (stat != 0) {
      stat = 0;
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => LogPage()));
    }
  } else if (index == 1) {
    if (stat != 1) {
      stat = 1;
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => LogPage()));
    }
  } else if (index == 2) {
    if (stat != 2) {
      stat = 2;
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => LogPage()));
    }
  }
}
