import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gcf_projects_app/frontend/home_page.dart';
import 'package:gcf_projects_app/frontend/alert_popups.dart';
import 'package:gcf_projects_app/frontend/burger_menu_drawer.dart';
import 'package:gcf_projects_app/backend/globals.dart';

String currentTable = "pendingUsers";
String currentItemMenu = "Edit User Role...";

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
        backgroundColor: gcfBG,
        appBar: AppBar(
          backgroundColor: gcfGreen,
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
          fixedColor: gcfGreen,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.rate_review),
                title: Text('New Users')),
            BottomNavigationBarItem(
                icon: Icon(Icons.timeline), title: Text('Active Users')),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.add), title: Text('Edit Profile')),
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

  void updatePage(BuildContext context, int index) {
    if (index == 0) {
      currentTable = "pendingUsers";
    } else if (index == 1) {
      currentTable = "users";
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
    String numberData = data['number'];
    String role = "";

    if (currentTable == "users") {
      role = data['role'];

      try {
        Firestore.instance
            .collection("users")
            .reference()
            .where("name", isEqualTo: userName)
            .where("number", isEqualTo: numberData)
            .getDocuments()
            .then((onValue) {
          var doc = onValue.documents[0];
          roleStatus = doc['role'];
        }).catchError((onError) {});
      } catch (_) {
        popUpInfo(context, "Error",
            "A connection error was detected. Please check if you're connected to the internet.");
      }
    }

    try {
      if (numberData != number) {
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
                          ? Text("Number: $numberData")
                          : Text("Number: $numberData\nRole: $role"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ButtonTheme.bar(
                          child: ButtonBar(
                            children: <Widget>[
                              RaisedButton(
                                color: Color.fromARGB(200, 0, 0, 0),
                                child: (currentTable == "pendingUsers")
                                    ? const Text(
                                        'Delete Request',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                        ),
                                      )
                                    : const Text(
                                        'Delete Account',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                onPressed: () {
                                  if (data['number'] == number) {
                                    popUpInfo(
                                        context,
                                        "Alert!",
                                        "You can't delete your own account." +
                                            "\nTo delete an account you must press delete on an account that doesn't belong to you.");
                                  } else if (!isAdmin) {
                                    String _type =
                                        (currentTable == "pendingUsers")
                                            ? "requests"
                                            : "accounts";
                                    popUpInfo(context, "Error",
                                        "Failed to delete account. Only the Administrator can delete $_type.");
                                  } else {
                                    Firestore.instance
                                        .collection(currentTable)
                                        .document(data.documentID)
                                        .delete()
                                        .catchError((onError) {
                                      popUpInfo(context, "Error",
                                          "Failed to delete user");
                                    });
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
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (!isAdmin) {
                                        popUpInfo(context, "Alert",
                                            "Failed to approve user. Only the Administrator can approve new user to the system");
                                      } else {
                                        Map<String, dynamic> newUserData =
                                            new Map();

                                        newUserData['name'] = data['name'];
                                        newUserData['number'] = data['number'];
                                        newUserData['password'] =
                                            data['password'];
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
                                                .setData(newUserData)
                                                .catchError((onError) {});
                                            Firestore.instance
                                                .collection("pendingUsers")
                                                .document(data.documentID)
                                                .delete()
                                                .catchError((onError) {});
                                            popUpInfo(context, "User Added",
                                                "Users has been added successfully.");
                                          } else {
                                            popUpInfo(context, "User Exists",
                                                "Couldn't add new user because they already exists in the database.");
                                            Firestore.instance
                                                .collection("pendingUsers")
                                                .document(data.documentID)
                                                .delete()
                                                .catchError((onError) {});
                                          }
                                        }).catchError((onError) {
                                          popUpInfo(context, "Error",
                                              "Failed to add new user.");
                                        });
                                      }
                                    },
                                  )
                                : DropdownButton(
                                    value: currentItemMenu,
                                    items: items,
                                    onChanged: (_data) {
                                      setState(() {
                                        currentItemMenu = _data;
                                        if (isAdmin) {
                                          if (_data != "Edit User Role...") {
                                            Map roleUpdate =
                                                new Map<String, String>();
                                            String name = data['name'];

                                            roleUpdate['role'] =
                                                currentItemMenu;
                                            Firestore.instance
                                                .collection("users")
                                                .document(data.documentID)
                                                .updateData(roleUpdate)
                                                .catchError((onError) {
                                              popUpInfo(context, "Error",
                                                  "Failed to update user role. Check your connection and try again");
                                            });
                                            popUpInfo(context, "Success",
                                                "$name's role has been updated!.");
                                            currentItemMenu =
                                                "Edit User Role...";
                                          }
                                        } else {
                                          currentItemMenu = "Edit User Role...";
                                          popUpInfo(context, "Alert",
                                              "Failed to update user role. Only the Administrator can update roles. Contact the Administrator for more information.");
                                        }
                                      });
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
      } else {
        return Padding(
          padding: EdgeInsets.all(0.0),
        );
      }
    } catch (_) {
      return Padding(
        padding: EdgeInsets.all(0.0),
      );
    }
  }
}
