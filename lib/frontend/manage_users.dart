import 'package:flutter/material.dart';
import 'home_page.dart';
import 'alert_popups.dart';
import 'burger_menu_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageUsers extends StatefulWidget{
  @override
  State createState() => new _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers>{
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

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('pendingUsers').snapshots(),
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

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
    child: Container(
        child: Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person, size: 40.0,),
            title: Text(
              "Name: $name",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Number: $number"),
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
                        Firestore.instance.collection("pendingUsers").document(data.documentID).delete();
                      },
                    )
                  ],
                ),
              ),
              ButtonTheme.bar(
                child: ButtonBar(
                  children: <Widget>[
                    RaisedButton(
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

                        Firestore.instance.collection("users").document(data.documentID).get().then((doc) {
                          if (!doc.exists){
                            Firestore.instance.collection("users").document(data.documentID).setData(newUserData);
                            Firestore.instance.collection("pendingUsers").document(data.documentID).delete();
                            popUpInfo(context, "User Added", "Users has been added successfully.");
                          }else{
                            popUpInfo(context, "User Exists", "Couldn't add new user because they already exists in the database.");
                            Firestore.instance.collection("pendingUsers").document(data.documentID).delete();
                          }
                        });
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    )),
  );
}