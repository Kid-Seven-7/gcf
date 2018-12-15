import 'package:flutter/material.dart';

import 'package:gcf_projects_app/backend/globals.dart';
import 'project_file_card.dart';

class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() => new _LogPageState();
}

class _LogPageState extends State<LogPage> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  _handleDrawer() {
    _key.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 140, 188, 63),
          title: Text("Log Page"),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: _handleDrawer,
          ),
          actions: <Widget>[
            Image.asset('assets/images/gcf_white.png'),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext log_item, int index){
                  return new Column(
                    children: <Widget>[
                      Text("test$index")
                    ],
                  );
                }
              ),
            )
//            LogItem()
          ],
        ) ,
//        bottomNavigationBar: NavBar(),
//        drawer: OpenDrawer()
    );
  }
}

ListTile OpenLog(){
  var item = LogItem();
}

class LogItem extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.assignment),
      title: const Text('The for the narrator'),
    );
  }
}

