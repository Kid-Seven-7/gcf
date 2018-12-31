import 'package:flutter/material.dart';
import 'home_page.dart';
import 'alert_popups.dart';
import 'burger_menu_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gcf_projects_app/backend/globals.dart';

String currentTable = "pendingUsers";

class ManageUsers extends StatefulWidget {
  @override
  State createState() => new _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
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
          title: Text("Manage Users"),
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
          currentIndex: _currentIndex,
          fixedColor: Color.fromARGB(255, 140, 188, 63),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.rate_review),
                title: Text('New Users')),
            BottomNavigationBarItem(
                icon: Icon(Icons.timeline), title: Text('Active Users')),
            BottomNavigationBarItem(
                icon: Icon(Icons.add), title: Text('Edit Profile')),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              updatePage(context, index);
            });
          },
        ),
        drawer: OpenDrawer());
  }
}

void updatePage(BuildContext context, int index) {
  if (index == 0) {
    currentTable = "pendingUsers";
  } else if (index == 1) {
    currentTable = "users";
  }else if (index == 2){
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context){
        return new UserProfileUpdate();
      },
      fullscreenDialog: true,
    ));
  }
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection(currentTable).snapshots(),
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
  String name = data['name'];
  String number = data['number'];
  String role = "";
  if (currentTable == "users") {
    role = data['role'];
  }

  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      child: Container(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.person,
                  size: 40.0,
                ),
                title: Text(
                  "Name: $name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: (currentTable == "pendingUsers")
                    ? Text("Number: $number")
                    : Text("Number: $number\nRole: $role"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // Chip(
                  //   avatar: CircleAvatar(
                  //     backgroundColor: Colors.grey.shade800,
                  //     child: Text(''),
                  //   ),
                  //   // label: Text(record.projectForeman),
                  // ),
                  ButtonTheme.bar(
                    child: ButtonBar(
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.blueGrey.shade700,
                          child: const Text(
                            'Delete Request',
                            style: TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
                          onPressed: () {
                            if (data['name'] == userName) {
                              popUpInfo(
                                  context,
                                  "Alert!",
                                  "You can't delete your own account." +
                                      "\nTo delete an account you must press delete on an account that doesn't belong to you.");
                            } else {
                              Firestore.instance
                                  .collection(currentTable)
                                  .document(data.documentID)
                                  .delete();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  ButtonTheme.bar(
                      child: ButtonBar(
                    children: <Widget>[
                      (currentTable == "pendingUsers")
                          ? RaisedButton(
                              child: const Text(
                                'Approve User',
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                              onPressed: () {
                                Map<String, dynamic> newUserData = new Map();

                                newUserData['name'] = data['name'];
                                newUserData['number'] = data['number'];
                                newUserData['password'] = data['password'];
                                newUserData['role'] = "user";

                                Firestore.instance
                                    .collection("users")
                                    .document(data.documentID)
                                    .get()
                                    .then((doc) {
                                  if (!doc.exists) {
                                    Firestore.instance
                                        .collection("users")
                                        .document(data.documentID)
                                        .setData(newUserData);
                                    Firestore.instance
                                        .collection("pendingUsers")
                                        .document(data.documentID)
                                        .delete();
                                    popUpInfo(context, "User Added",
                                        "Users has been added successfully.");
                                  } else {
                                    popUpInfo(context, "User Exists",
                                        "Couldn't add new user because they already exists in the database.");
                                    Firestore.instance
                                        .collection("pendingUsers")
                                        .document(data.documentID)
                                        .delete();
                                  }
                                });
                              },
                            )
                          : RaisedButton(
                              child: const Text(
                                'Edit User',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                //Edit user code
                              },
                            )
                    ],
                  )),
                ],
              )
            ],
          ),
        ),
      ));
}
