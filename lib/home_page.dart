import 'package:flutter/material.dart';

import 'add_project.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 140, 188, 63),
        leading: Image.asset('assets/images/gcf_white.png'),
        title: Text('Home Screen'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.library_books),
                  title: Text('Project name'),
                  subtitle: Text('Project discription'),
                ),
                ButtonTheme.bar(
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('View project'),
                        onPressed: (){},
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Color.fromARGB(255, 140, 188, 63),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondScreen()),
              );
            },
          )
//          RaisedButton(
//            child: Text('Proceed'),
//            onPressed: () {
//              Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => SecondScreen()),
//              );
//            },
//          )
        ],
      ),
    );
  }
}
