import 'package:flutter/material.dart';
import 'home_page.dart';

class CreateProjectPage extends StatelessWidget {
  final ProjectName = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 140, 188, 63),
        title: Text("Add Project"),
        actions: <Widget>[
          Image.asset('assets/images/gcf_white.png'),
        ],
      ),
      body: ListView(
        children: <Widget>[
        Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.centerLeft,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Name'),
//            keyboardType: TextInputType.text,
            controller: ProjectName,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Location'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Client'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Type'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Foreman'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Budget'),
          ),
          TextField(
            decoration: InputDecoration(
                labelText: 'Project Start Date',
                hintText: 'DD/MM/YYYY',
                hintStyle: TextStyle(
                    fontStyle: FontStyle.italic
                )
            ),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project End Date'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Color.fromARGB(255, 140, 188, 63),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(backgroundColor: Colors.black ,icon: Icon(Icons.cancel), title: Text('Cancel')),
          BottomNavigationBarItem(icon: Icon(Icons.check), title: Text('Create')),
        ],
        onTap: (index)  {
          _onItemTapped(context, index, ProjectName.text);
        },
      ),
    );
  }
}

void _onItemTapped(BuildContext context , int index, String name) {
  if (index == 0) {
    debugPrint('Cancel');
    Navigator.pop(
        context, MaterialPageRoute(builder: (context) => CreateProjectPage()));
  } else if (index == 1) {
    debugPrint('Create');
    debugPrint(name);
      _newproject(context, name);
  }
}

Future<void> _newproject(BuildContext context, String name) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Create Project'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to create\n$name?'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pop(context, MaterialPageRoute(builder: (context) => CreateProjectPage()));
            },
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
