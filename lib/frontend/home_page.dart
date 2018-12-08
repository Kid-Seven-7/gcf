import 'package:flutter/material.dart';

import 'add_project.dart';
import 'burger_menu_drawer.dart';
import 'project_file_card.dart';

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
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child:  Column(
          children: <Widget>[
            ProjectCard(),
          ],
        ),
      ) ,

      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Color.fromARGB(255, 140, 188, 63),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(backgroundColor: Colors.black ,icon: Icon(Icons.rate_review), title: Text('View Report')),
          BottomNavigationBarItem(icon: Icon(Icons.timeline), title: Text('View Statistics')),
          BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('Add project')),
        ],
        onTap: (index)  {
          _onItemTapped(context, index);
        },
      ),
      drawer: OpenDrawer()
    );
  }
}

void _onItemTapped(BuildContext context , int index) {
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
