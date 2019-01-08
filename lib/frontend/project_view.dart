import 'dart:async';
import 'camera.dart';
import 'home_page.dart';
import 'alert_popups.dart';
import 'burger_menu_drawer.dart';
import 'package:flutter/material.dart';
import '../backend/system_padding.dart';
import 'expenses_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../backend/database_engine.dart';

BuildContext _context;
Record _record;
DataBaseEngine dataBaseEngine = new DataBaseEngine();
Timer navTimer;

class ProjectCard extends StatefulWidget {
  ProjectCard(Record record) {
    _record = record;
  }
  @override
  State createState() => new ProjectCardState(_record);
}

class Navigations {
  static const String viewSitePictures = "View Site Pictures";
  static const String addSitePicture = "Add Site Image";

  static const List<String> choices = <String>[
    viewSitePictures,
    addSitePicture
  ];
}

class ProjectCardState extends State<ProjectCard> {
  Record record;
  int _currentIndex = 0;
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  _handleDrawer() {
    _key.currentState.openDrawer();
  }

  ProjectCardState(Record record) {
    this.record = record;
  }

  void dispose() async {
    super.dispose();
    navTimer.cancel();
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
                      onPressed: () {
                        Navigator.of(context).push(
                          new MaterialPageRoute(
                              builder: (builder) => CameraPage(
                                  record.projectID, "expensesImages")),
                        );
                      },
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
          currentIndex: _currentIndex,
          fixedColor: Color.fromARGB(255, 140, 188, 63),
          items: <BottomNavigationBarItem>[
            // BottomNavigationBarItem(
            //     backgroundColor: Colors.black,
            //     icon: Icon(Icons.image),
            //     title: Text('View Project Images')),
            BottomNavigationBarItem(
                icon: Icon(Icons.money_off), title: Text('View Expanses')),
            BottomNavigationBarItem(
                icon: Icon(Icons.toc), title: Text('View TODO-List')),
          ],
          onTap: (index) {
            if (index == 0) {
              Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (context) =>
                        ExpensesView(record.projectID, "expensesImages")),
              );
            }
            if (index == 1) {
              if (record.projectTodo != null && record.projectTodo != ",") {
                showTodoList(context, "TODO List", record.projectTodo);
              } else {
                popUpInfo(context, "Alert", "TODO List is currently empty.");
              }
              // showTodoList(context, "TODO List", record.projectTodo);
            }
            setState(() {
              _currentIndex = index;
            });
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
      child: new SystemPadding(
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
                child:
                    (action == "add") ? const Text('CANCEL') : const Text(''),
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

void selectedNav(String choice) {
  if (choice == "Add Site Image") {
    Navigator.of(_context).push(new MaterialPageRoute(
        builder: (context) => CameraPage(_record.projectID, "projectImages")));
  } else if (choice == "View Site Pictures") {
    Navigator.of(_context).push(
      new MaterialPageRoute(
          builder: (context) =>
              ExpensesView(_record.projectID, "projectImages")),
    );
  }
}

Widget _buildBody(BuildContext context, Record record) {
  _context = context;
  var textStyle = TextStyle(fontWeight: FontWeight.bold);
  return new Card(
    margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
    child: ListView(
      padding: EdgeInsets.only(top: 10.0),
      children: <Widget>[
        PopupMenuButton<String>(
          icon: Icon(
            Icons.camera,
            color: Colors.blueGrey.shade700,
            size: 40,
          ),
          onSelected: selectedNav,
          itemBuilder: (BuildContext context) {
            return Navigations.choices.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ButtonTheme.bar(
              child: ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    color: Colors.blueGrey.shade700,
                    child: const Text(
                      'Close Project',
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                    onPressed: () {
                      Firestore.instance
                          .collection("activeProjects")
                          .reference()
                          .where("projectID", isEqualTo: record.projectID)
                          .getDocuments()
                          .then((_onValue) {
                        //Moving project from the active projects to the log
                        var doc = _onValue.documents[0];
                        dataBaseEngine.addData("log", doc.data);
                        var docID = doc.documentID;

                        //Deleting project from the activeProjects collection
                        Firestore.instance
                            .collection("activeProjects")
                            .document(docID)
                            .delete();
                        popUpInfo(context, "Success",
                            "Project has been closed successfully.");
                        navTimer = Timer(Duration(seconds: 3), () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        });
                      }).catchError((onError) {
                        popUpInfo(context, "Error",
                            "Failed to close project. Please check your internet connection and try again.");
                      });
                    },
                  ),
                  RaisedButton(
                    color: Colors.blueGrey.shade700,
                    child: const Text(
                      'Delete Project',
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                    onPressed: () {
                      Firestore.instance
                          .collection("activeProjects")
                          .reference()
                          .where("projectID", isEqualTo: record.projectID)
                          .getDocuments()
                          .then((_onValue) {
                        //Referencing project to delete
                        var doc = _onValue.documents[0];
                        var docID = doc.documentID;

                        //Deleting project from the activeProjects collection
                        deleteDialog(
                            context,
                            "Alert",
                            "You're about to delete the project (${record.projectName}). Continue?",
                            docID);
                      }).catchError((onError) {
                        popUpInfo(context, "Error",
                            "Failed to delete project. Please check your internet connection and try again.");
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
  );
}

void deleteDialog(
    BuildContext context, String header, String message, var docID) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 5.0),
          title: new Text(header),
          content: new Text(message),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('Confirm'),
              onPressed: () {
                Firestore.instance
                    .collection("activeProjects")
                    .document(docID)
                    .delete()
                    .catchError((onError) {});

                Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
          ],
        );
      });
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
