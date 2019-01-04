import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String todoList;
String patchedList = "";

class TodoList extends StatefulWidget {
  @override
  TodoList(String list) {
    todoList = list;
  }
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //Converting a string to a list
    var todo = todoList.split(",");
    String patchedList = "";

    todo.forEach((data) {
      if (data != "") {
        patchedList = patchedList + "\n - " + data;
      }
    });

    print(patchedList);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 140, 188, 63),
        title: Text("Update TODO-List"),
        actions: <Widget>[
          Image.asset('assets/images/gcf_white.png'),
        ],
      ),
      body: Text(
        "Todo List\n $patchedList",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
