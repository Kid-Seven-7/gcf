import 'splash.dart';
import 'log_page.dart';
import 'home_page.dart';
import 'manage_users.dart';
import 'notifications.dart';
import 'package:flutter/material.dart';
import 'package:gcf_projects_app/backend/globals.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final storage = new FlutterSecureStorage();
Firestore firestore = new Firestore();

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
    firestore.settings(timestampsInSnapshotsEnabled: true, sslEnabled: true);

    firestore.collection("notifications").getDocuments().then((value) {
      notifications = value.documents.length;
    }).catchError((onError) {});

    try {
      firestore
          .collection("users")
          .reference()
          .where("name", isEqualTo: userName)
          .where("number", isEqualTo: number)
          .getDocuments()
          .then((onValue) {
        var doc = onValue.documents[0];
        roleStatus = doc['role'];
      }).catchError((onError) {});
    } catch (_) {}

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
            image: DecorationImage(
              image: new AssetImage("assets/images/burger_back.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
            ),
            color: Colors.blueGrey.shade900,
            backgroundBlendMode: BlendMode.darken,
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
          onTap: () {
            openpage(context, "Projects");
          },
        ),
        ListTile(
          leading: Icon(Icons.assignment),
          title: Text(
            'Log',
            style: _navMenuText,
          ),
          onTap: () {
            openpage(context, "Log");
          },
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
          title: (notifications > 0)
              ? Text(
                  'Notifications($notifications)',
                  style: TextStyle(fontSize: 18.0, color: Colors.redAccent),
                )
              : Text(
                  'Notifications',
                  style: _navMenuText,
                ),
          onTap: () {
            openpage(context, "Notifications");
          },
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
    if (currentPage != "Manage Users") {
      currentPage = "Manage Users";

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ManageUsers()));
    } else {
      Navigator.pop(context);
    }
  }
  if (page == "LogOut") {
    currentPage = "";
    Navigator.pop(context);
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => SplashScreen()));
  }
  if (page == "Log") {
    if (currentPage != "Log") {
      currentPage = "Log";
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => LogPage()));
    } else {
      Navigator.pop(context);
    }
  }
  if (page == "Projects") {
    if (currentPage != "Projects") {
      currentPage = "Projects";

      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.pop(context);
    }
  }
  if (page == "Notifications") {
    if (currentPage != "Notifications") {
      currentPage = "Notifications";

      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => Notifications()));
    } else {
      Navigator.pop(context);
    }
  }
}
