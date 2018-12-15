import 'manage_users.dart';
import 'package:flutter/material.dart';
import 'package:gcf_projects_app/backend/globals.dart';
import 'splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();
void _handleDrawer() {
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  key.currentState.openDrawer();
}

class OpenDrawer extends StatelessWidget {
  final TextStyle _navMenuText = TextStyle(fontSize: 18.0, color: Colors.black);
  final TextStyle _navMenuHeading =
      TextStyle(fontSize: 25.0, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          padding: EdgeInsets.all(50.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  ),
                  Text(
                    userName,
                    style: _navMenuHeading,
                  ),
                ],
              ),
              Text(
                'Title: $roleStatus',
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.green.shade500,
          ),
        ),
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text(
            'Manage Users',
            style: _navMenuText,
          ),
          onTap: () {
            openpage(context, "Manage Users");
          },
        ),
        ListTile(
          leading: Icon(Icons.library_books),
          title: Text(
            'Projects',
            style: _navMenuText,
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.assignment),
          title: Text(
            'Log',
            style: _navMenuText,
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.timeline),
          title: Text(
            'Statistics',
            style: _navMenuText,
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.rate_review),
          title: Text(
            'Reports',
            style: _navMenuText,
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text(
            'Notifications',
            style: _navMenuText,
          ),
          onTap: () {},
        ),
        Divider(
          height: 20.0,
          color: Colors.black,
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text(
            'Settings',
            style: _navMenuText,
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.power),
          title: Text(
            'Log Out',
            style: _navMenuText,
          ),
          onTap: () async {
            await storage.delete(key: "name");
            await storage.delete(key: "role");
            await storage.delete(key: "rememberMe");

            openpage(context, "LogOut");
          },
        ),
      ],
    ));
  }
}

void openpage(BuildContext context, String page) {
  if (page == "Manage Users") {
    print(context.findRenderObject());
    Navigator.push(context, MaterialPageRoute(builder: (context) => ManageUsers()));
  }

  if (page == "LogOut"){
    Navigator.pop(context);
    Navigator.of(context).pushReplacement(
                new MaterialPageRoute(builder: (context) => SplashScreen()));
  }
}