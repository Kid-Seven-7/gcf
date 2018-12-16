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
  return new Card(
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
                    onPressed: () {},
                  )
                ],
              ),
            )
          ],
        ),
      ],
    ),
  );
}
