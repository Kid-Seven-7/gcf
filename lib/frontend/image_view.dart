import 'package:flutter/material.dart';

import 'package:gcf_projects_app/frontend/burger_menu_drawer.dart';
import 'package:gcf_projects_app/backend/globals.dart';

String _image = "";

class ImageView extends StatefulWidget {
  ImageView(String imageUrl) {
    _image = imageUrl;
  }
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
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
          title: Text("Image View"),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: _handleDrawer,
          ),
          actions: <Widget>[
            Image.asset('assets/images/gcf_white.png'),
          ],
        ),
        body: _buildImage(context),
        drawer: OpenDrawer());
  }

  Widget _buildImage(BuildContext context) {
    return Container(
      child: new Center(
        child: Stack(
          children: <Widget>[
            new Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: gcfGreen, width: 10),
                  borderRadius: BorderRadius.circular(20)),
              color: gcfBG,
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/loading.gif',
                  image: _image,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
