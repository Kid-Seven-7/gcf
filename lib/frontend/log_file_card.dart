import 'package:flutter/material.dart';

import 'package:gcf_projects_app/frontend/burger_menu_drawer.dart';
import 'package:gcf_projects_app/frontend/log_page.dart';

class LogCard extends StatefulWidget {
  Log log;

  LogCard(Log log) {
    this.log = log;
  }

  @override
  State createState() => new LogCardState(log);
}

class LogCardState extends State<LogCard> {
  Log log;
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  _handleDrawer() {
    _key.currentState.openDrawer();
  }

  LogCardState(Log log) {
    this.log = log;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 140, 188, 63),
          title: Text("Project Log"),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: _handleDrawer,
          ),
          actions: <Widget>[
            Image.asset('assets/images/gcf_white.png'),
          ],
        ),
        body: _buildBody(context, log),
        drawer: OpenDrawer());
  }
}

Widget _buildBody(BuildContext context, Log log) {
  return new Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.library_books),
          title: Text(
            log.projectName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(log.projectClient),
        ),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.black87,
                child: Text('FM'),
              ),
              label: Text(log.projectForeman),
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
