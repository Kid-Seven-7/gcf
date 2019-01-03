import 'package:flutter/material.dart';
import 'home_page.dart';
import 'burger_menu_drawer.dart';

class ProjectCard extends StatefulWidget {
  Record record;
  ProjectCard(Record record) {
    this.record = record;
  }
  @override
  State createState() => new ProjectCardState(record);
}

class ProjectCardState extends State<ProjectCard> {
  Record record;
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  _handleDrawer() {
    _key.currentState.openDrawer();
  }

  ProjectCardState(Record record) {
    this.record = record;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        backgroundColor: Colors.blueGrey.shade900,
        appBar: AppBar(
          backgroundColor: Colors.green.shade500,
          title: Text("Project View"),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: _handleDrawer,
          ),
          actions: <Widget>[
            Image.asset('assets/images/gcf_white.png'),
          ],
        ),
        body: _buildBody(context, record),
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

Widget _buildBody(BuildContext context, Record record) {
  var textStyle = TextStyle(fontWeight: FontWeight.bold);
  return new Card(
    margin: EdgeInsets.all(10.0),
    child: ListView(
      // crossAxisAlignment: CrossAxisAlignment.center,
      padding: EdgeInsets.only(top: 10.0),
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.library_books),
          title: Text(record.projectName, style: textStyle),
          subtitle: Text(record.projectDescription),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text("Forman: ", style: textStyle),
          subtitle: Text(record.projectForeman),
        ),
        ListTile(
          leading: Icon(Icons.perm_identity),
          title: Text(
            "Project Client: ",
            style: textStyle,
          ),
          subtitle: Text(record.projectClient),
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text("Project Location: ", style: textStyle),
          subtitle: Text(record.projectLocation),
        ),
        ListTile(
          leading: Icon(Icons.monetization_on),
          title: Text(
            "Project Budget:",
            style: textStyle,
          ),
          subtitle: Text("R${record.projectBudget}"),
        ),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text(
            "Proejct Type: ",
            style: textStyle,
          ),
          subtitle: Text(record.projectType),
        ),
        ListTile(
          leading: Icon(Icons.bookmark),
          title: Text(
            "Project Start Date: ",
            style: textStyle,
          ),
          subtitle: Text(record.projectStartDate),
        ),
        ListTile(
          leading: Icon(Icons.bookmark_border),
          title: Text(
            "Project End Date: ",
            style: textStyle,
          ),
          subtitle: Text(record.projectEndDate),
        ),
      ],
    ),
  );
}
