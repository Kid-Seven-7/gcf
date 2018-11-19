import 'package:flutter/material.dart';

//debug
import 'package:flutter/foundation.dart';
import 'dart:developer';

import 'add_project.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  int _counter = 0;
  _handleDrawer() {
    _key.currentState.openDrawer();

//    setState(() {
//      ///DO MY API CALLS
//      _counter++;
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 140, 188, 63),
        title: Text("Home Screen"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _handleDrawer,
        ),
        actions: <Widget>[
          Image.asset('assets/images/gcf_white.png'),
        ],
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.library_books),
                  title: Text('Project name'),
                  subtitle: Text('Project discription'),
                ),
                ButtonTheme.bar(
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('View project'),
                        onPressed: () {},
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.rate_review), title: Text('View Report')),
          BottomNavigationBarItem(icon: Icon(Icons.timeline), title: Text('View Statistics')),
          BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('Add project')),
        ],
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.all(50.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.account_circle),
                        Text(
                          'User Name',
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                        ),
                      ],
                    ),
                    Text('Title')
                  ],
                ),

                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 96, 129, 42),
                ),
              ),
              ListTile(
                leading: Icon(Icons.library_books),
                title: Text('Projects',style: TextStyle(fontSize: 18.0,),),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.assignment),
                title: Text('Log',style: TextStyle(fontSize: 18.0,),),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.timeline),
                title: Text('Statistics',style: TextStyle(fontSize: 18.0,),),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.rate_review),
                title: Text('Reports',style: TextStyle(fontSize: 18.0,),),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications',style: TextStyle(fontSize: 18.0,),),
                onTap: () {},
              ),
              Divider(
                height: 20.0,
                color: Colors.black,
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings',style: TextStyle(fontSize: 15.0,),),
                onTap: () {},
              ),
            ],
          )),
    );
  }
}

void _onItemTapped(int index){
  if (index == 0){
    debugPrint('View Report');
  }else if (index == 1){
    debugPrint('View Statistics');
  }else if (index == 2){
    debugPrint('Add project');
    Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateProjectPage()));
  }

}