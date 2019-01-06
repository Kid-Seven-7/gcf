import 'alert_popups.dart';
import 'burger_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gcf_projects_app/backend/globals.dart';

String _projectID = "";

class ExpensesView extends StatefulWidget {
  ExpensesView(String projectID) {
    _projectID = projectID;
  }
  _ExpensesViewState createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<ExpensesView> {
  int _currentIndex = 0;
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  _handleDrawer() {
    _key.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        backgroundColor: Colors.blueGrey.shade900,
        appBar: AppBar(
          backgroundColor: Colors.green.shade500,
          title: Text("Project Expenses"),
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
                icon: Icon(Icons.monetization_on),
                title: Text('Budget')),
            BottomNavigationBarItem(
                icon: Icon(Icons.money_off), title: Text('Total Expenses')),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.add), title: Text('Edit Profile')),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        drawer: OpenDrawer());
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("expensesImages")
          .reference()
          .where("projectID", isEqualTo: _projectID)
          .snapshots(),
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
    String expenseAmount = data['amount'];
    String expenseName = data['expenseName'];
    String uploadedBy = data['uploadedBy'];
    String imageUrl = data['imageUrl'];

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        child: Container(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.attach_money,
                    size: 40.0,
                  ),
                  title: Text(
                    "Expense: $expenseName",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle:
                      Text("Amount: R$expenseAmount\nUploaded By: $uploadedBy"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ButtonTheme.bar(
                      child: ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text(
                              'View Image',
                              style: TextStyle(
                                color: Color.fromARGB(255, 140, 188, 63),
                              ),
                            ),
                            onPressed: () {
                              // _viewproject();
                            },
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
