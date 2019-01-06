import 'package:flutter/material.dart';
import 'alert_popups.dart';
import 'burger_menu_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gcf_projects_app/backend/globals.dart';

String currentTable = "pendingUsers";
String currentItemMenu = "Edit User Role...";
int navBarIndex = 0;

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int _currentIndex = 0;

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  _handleDrawer() {
    _key.currentState.openDrawer();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        backgroundColor: Colors.blueGrey.shade900,
        appBar: AppBar(
          backgroundColor: Colors.green.shade500,
          title: Text("Notifications"),
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
          currentIndex: navBarIndex,
          fixedColor: Color.fromARGB(255, 140, 188, 63),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.delete_forever),
                title: Text('Delete All')),
            BottomNavigationBarItem(
                icon: Icon(Icons.timeline), title: Text('Mark All Read')),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.add), title: Text('Edit Profile')),
          ],
          onTap: (index) {
            setState(() {
              navBarIndex = index;
              updatePage(context, index);

              if (index == 1) {
                index = 0;
                navBarIndex = 0;
              }
            });
          },
        ),
        drawer: OpenDrawer());
  }

  void updatePage(BuildContext context, int index) {
    if (index == 0) {
      if (isAdmin) {
        Firestore.instance
            .collection("notifications")
            .getDocuments()
            .then((snapshot) {
          for (var doc in snapshot.documents) {
            doc.reference.delete();
          }
        }).catchError((onError) {});
        Firestore.instance
            .collection("notifications")
            .getDocuments()
            .then((value) {
          notifications = value.documents.length;
        }).catchError((onError) {});
      } else {
        popUpInfo(context, "Alert",
            "Error trying to delete notifications. Only an Administrator can delete notifications");
      }
    }
    if (index == 1) {
      messageIcon = Icons.mail;
    }
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("notifications").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildNewCard(context, data)).toList(),
    );
  }

  Widget _buildNewCard(BuildContext context, DocumentSnapshot data) {
    String notificationTitle = data['title'];
    String notificationMessage = data['message'];

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        child: Container(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    messageIcon,
                    size: 40.0,
                  ),
                  title: Text(
                    "$notificationTitle",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("$notificationMessage"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ButtonTheme.bar(
                      child: ButtonBar(
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.blueGrey.shade700,
                            child: const Text(
                              'Delete Message',
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
                            onPressed: () {
                              if (isAdmin){
                              Firestore.instance
                                  .collection("notifications")
                                  .document(data.documentID)
                                  .delete();

                              Firestore.instance
                                  .collection("notifications")
                                  .getDocuments()
                                  .then((value) {
                                notifications = value.documents.length;
                              });
                              }else{
                                popUpInfo(context, "Alert", "Error trying to delete notification. Only an Administrator can delete notifications");
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

void sendMessage(BuildContext context, String title, String message) {
  Map newNotification = new Map<String, String>();
  newNotification['title'] = title;
  newNotification['message'] = message;

  try {
    Firestore.instance
        .collection("notifications")
        .document()
        .setData(newNotification);
  } catch (_) {
    popUpInfo(context, "Error",
        "Unable to send notification. Please check your internet connection");
  }
}
