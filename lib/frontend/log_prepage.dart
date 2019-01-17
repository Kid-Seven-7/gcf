import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:gcf_projects_app/frontend/burger_menu_drawer.dart';
// import 'package:gcf_projects_app/frontend/stats_widgets.dart';
import 'package:gcf_projects_app/frontend/alert_popups.dart';
import 'package:gcf_projects_app/frontend/log_page.dart';
import 'package:gcf_projects_app/backend/globals.dart';

var stat = 1;
int resTotal = 0;
int comTotal = 0;
int allTotal = 0;

/*
  Parameter:

  Function:

  Return:

*/
class LogPrePage extends StatefulWidget {
  @override
  _LogPrePageState createState() => new _LogPrePageState();
}

/*
  Parameter:

  Function:

  Return:

*/
class _LogPrePageState extends State<LogPrePage> {
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
          title: Text("Project Log"),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: _handleDrawer,
          ),
          actions: <Widget>[
            Image.asset('assets/images/gcf_white.png'),
          ],
        ),
        body: _buildBody(context),
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
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: allStatistics(context, log)
  );
}

/*
  Parameter:

  Function:

  Return:

*/
class _Log {
  String projectName;
  String projectForeman;
  String projectDescription;
  String projectClient;
  String projectType;
  String projectLocation;
  String projectEndDate;
  String projectStartDate;
  String projectExpenses;
  String projectBudget;

  DocumentReference reference;

  _Log.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['projectName'] != null),
        assert(map['projectForeman'] != null),
        assert(map['projectDescription'] != null),
        assert(map['projectClient'] != null),
        assert(map['projectType'] != null),
        assert(map['projectLocation'] != null),
        assert(map['projectEndDate'] != null),
        assert(map['projectStartDate'] != null),
        assert(map['projectExpenses'] != null || map['projectExpenses'] == null),
        assert(map['projectBudget'] != null),
        projectName = map['projectName'],
        projectForeman = map['projectForeman'],
        projectDescription = map['projectDescription'],
        projectClient = map['projectClient'],
        projectType = map['projectType'],
        projectLocation = map['projectLocation'],
        projectEndDate = map['projectEndDate'],
        projectStartDate = map['projectStartDate'],
        projectExpenses = map['projectExpenses'],
        projectBudget = map['projectBudget'];

  _Log.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}

/*
  Parameter:

  Function:

  Return:

*/
Widget allStatistics(BuildContext context, Log currentLog) {
  allTotal += int.parse(currentLog.projectBudget);
  return Container(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            logListTile(
                context,
                currentLog.projectName, //Tile title
                currentLog.projectDescription, //Tile subtitle
                currentLog.projectType == "Business"
                    ? Icons.business //Tile icon
                    : Icons.home //Tile icon
                ,
                currentLog
            ),
          ],
        ),
      )
  );
}

/*
  Parameter:

  Function:

  Return:

*/
Widget logListTile(
    BuildContext context, String title, String subtitle, IconData icon, Log currentLog) {
  // var checked = true;

  return ListTile(
    leading: Icon(icon),
    isThreeLine: true,
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Text(subtitle),
    onTap: () {
      // debugPrint("clicked");
      // LogPage(currentLog);
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => LogPage(currentLog)));
    },
  );
}
