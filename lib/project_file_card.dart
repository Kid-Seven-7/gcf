import 'package:flutter/material.dart';

class ProjectCard extends StatefulWidget{
  @override
  State createState() => new ProjectCardState();
}

class ProjectCardState extends State<ProjectCard>{
  Widget build(BuildContext context){
    return new Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.library_books),
            title: Text('Project name'),
            subtitle: Text('Project discription'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: Text('FM'),
                ),
                label: Text('Fore Man'),
              ),
              ButtonTheme.bar(
                child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: const Text('View project', style: TextStyle(
                        color: Color.fromARGB(255, 140, 188, 63),
                      ),),
                      onPressed: () {_viewproject();},
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
}

void _viewproject(){

}