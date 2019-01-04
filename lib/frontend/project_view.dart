import 'package:flutter/material.dart';
import 'home_page.dart';
import 'burger_menu_drawer.dart';
import 'alert_popups.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectCard extends StatefulWidget {
  Record record;
  ProjectCard(Record record) {
    this.record = record;
  }
  @override
  State createState() => new ProjectCardState(record);
}

class ProjectCardState extends State<ProjectCard> {
  Record record;
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  _handleDrawer() {
    _key.currentState.openDrawer();
  }

  ProjectCardState(Record record) {
    this.record = record;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        backgroundColor: Colors.blueGrey.shade900,
        appBar: AppBar(
          backgroundColor: Colors.green.shade500,
          title: Text("Project View"),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: _handleDrawer,
          ),
          actions: <Widget>[
            Image.asset('assets/images/gcf_white.png'),
          ],
        ),
        persistentFooterButtons: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 35.0),
              child: ButtonTheme.bar(
                child: ButtonBar(
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.blueGrey.shade700,
                      child: const Text(
                        'Add Expense',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    RaisedButton(
                      color: Colors.blueGrey.shade700,
                      child: const Text(
                        'Add to TODO-List',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        _showDialog("add");
                      },
                    ),
                    RaisedButton(
                      color: Colors.blueGrey.shade700,
                      child: const Text(
                        'Delete Item',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        _showDialog("delete");
                      },
                    )
                  ],
                ),
              ))
        ],
        body: _buildBody(context, record),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Color.fromARGB(255, 140, 188, 63),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.rate_review),
                title: Text('View Report')),
            BottomNavigationBarItem(
                icon: Icon(Icons.money_off), title: Text('View Expanses')),
            BottomNavigationBarItem(
                icon: Icon(Icons.toc), title: Text('View TODO-List')),
          ],
          onTap: (index) {
            if (index == 2) {
              if (record.projectTodo != null && record.projectTodo != ",") {
                showTodoList(context, "TODO List", record.projectTodo);
              } else {
                popUpInfo(context, "Alert", "TODO List is currently empty.");
              }
              // showTodoList(context, "TODO List", record.projectTodo);
            }
          },
        ),
        drawer: OpenDrawer());
  }

  _showDialog(String action) async {
    String todoListItem;
    String currentTodoItem = "Delete item from TODO-List...";
    List<DropdownMenuItem<String>> todoItems = [
      DropdownMenuItem(
        value: "Delete item from TODO-List...",
        child: Text("Delete item from TODO-List..."),
      ),
    ];

    var todoList = record.projectTodo.split(",");
    todoList.forEach((todoItem) {
      if (todoItem != "") {
        if (todoItem != null) {
          DropdownMenuItem _item =
              DropdownMenuItem<String>(value: todoItem, child: Text(todoItem));
          todoItems.add(_item);
        }
      }
    });

    await showDialog<String>(
      context: context,
      child: new _SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: (action == "add")
                    ? new TextField(
                        scrollPadding: EdgeInsets.all(30),
                        autofocus: true,
                        decoration: new InputDecoration(
                            labelStyle: TextStyle(fontSize: 25),
                            hintStyle: TextStyle(fontSize: 15),
                            labelText: 'Add Item to list',
                            hintText: 'e.g Get new tools'),
                        onChanged: (data) {
                          todoListItem = data;
                        },
                      )
                    : DropdownButton(
                        value: currentTodoItem,
                        items: todoItems,
                        onChanged: (_data) {
                          setState(() {
                            currentTodoItem = _data;
                            if (currentTodoItem !=
                                "Delete item from TODO-List...") {
                              Navigator.of(context).pop();
                              if (record.projectTodo
                                  .contains(currentTodoItem)) {
                                String updatedTodo = record.projectTodo
                                    .replaceAll(currentTodoItem, "");

                                if (record.projectID != null) {
                                  Firestore.instance
                                      .collection("activeProjects")
                                      .reference()
                                      .where("projectID",
                                          isEqualTo: record.projectID)
                                      .getDocuments()
                                      .then((data) {
                                    var docs = data.documents;

                                    String docID = docs[0].documentID;

                                    if (docID != null) {
                                      Map _data = new Map<String, String>();
                                      _data['projectTodo'] = updatedTodo;
                                      Firestore.instance
                                          .collection("activeProjects")
                                          .document(docID)
                                          .updateData(_data);
                                    }
                                  });
                                } else {
                                  popUpInfo(context, "Error",
                                      "Unable to delete item from the list.\n Reason: Project-ID was not found.");
                                }
                              }
                              //Remove from database
                            }
                          });
                        },
                      ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text(''),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: (action == "add")
                    ? const Text('ADD')
                    : const Text('CANCEL'),
                onPressed: () {
                  if (action == "add") {
                    String newTodoList =
                        record.projectTodo + ", " + todoListItem;

                    // Adding item to the database
                    if (record.projectID != null) {
                      Firestore.instance
                          .collection("activeProjects")
                          .reference()
                          .where("projectID", isEqualTo: record.projectID)
                          .getDocuments()
                          .then((data) {
                        var docs = data.documents;

                        String docID = docs[0].documentID;

                        if (docID != null) {
                          Map _data = new Map<String, String>();
                          _data['projectTodo'] = newTodoList;
                          Firestore.instance
                              .collection("activeProjects")
                              .document(docID)
                              .updateData(_data);
                        }
                      });
                    } else {
                      popUpInfo(context, "Error",
                          "Unable to add item to list.\n Reason: Project-ID was not found.");
                    }
                  }
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}

Widget _buildBody(BuildContext context, Record record) {
  var textStyle = TextStyle(fontWeight: FontWeight.bold);
  return new Card(
    margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
    child: ListView(
      // crossAxisAlignment: CrossAxisAlignment.center,
      padding: EdgeInsets.only(top: 10.0),
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.library_books),
          title: Text(record.projectName, style: textStyle),
          subtitle: Text(record.projectDescription),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text("Forman: ", style: textStyle),
          subtitle: Text(record.projectForeman),
        ),
        ListTile(
          leading: Icon(Icons.perm_identity),
          title: Text(
            "Project Client: ",
            style: textStyle,
          ),
          subtitle: Text(record.projectClient),
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text("Project Location: ", style: textStyle),
          subtitle: Text(record.projectLocation),
        ),
        ListTile(
          leading: Icon(Icons.monetization_on),
          title: Text(
            "Project Budget:",
            style: textStyle,
          ),
          subtitle: Text("R${record.projectBudget}"),
        ),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text(
            "Proejct Type: ",
            style: textStyle,
          ),
          subtitle: Text(record.projectType),
        ),
        ListTile(
          leading: Icon(Icons.bookmark),
          title: Text(
            "Project Start Date: ",
            style: textStyle,
          ),
          subtitle: Text(record.projectStartDate),
        ),
        ListTile(
          leading: Icon(Icons.bookmark_border),
          title: Text(
            "Project End Date: ",
            style: textStyle,
          ),
          subtitle: Text(record.projectEndDate),
        ),
        // ButtonTheme.bar(
        //   child: ButtonBar(
        //     children: <Widget>[
        //       RaisedButton(
        //         color: Colors.blueGrey.shade700,
        //         child: const Text(
        //           'Mark Project As Complete',
        //           style: TextStyle(
        //             color: Colors.white,
        //           ),
        //         ),
        //         onPressed: () {},
        //       )
        //     ],
        //   ),
        // )
      ],
    ),
  );
}

void showTodoList(BuildContext context, String header, String list) {
  var todoList = list.split(",");
  String patchedList = "";

  todoList.forEach((data) {
    if (data != "") {
      patchedList = patchedList + "\n - " + data;
    }
  });

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 5.0),
          title: new Text(header),
          content: new Text(patchedList),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: EdgeInsets.only(top: 50),
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
