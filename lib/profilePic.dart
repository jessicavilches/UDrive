import 'package:flutter/material.dart';
import'package:image_picker/image_picker.dart';
import 'dart:io';

class profPic extends StatefulWidget{
  @override

  State<StatefulWidget> createState(){
    return new CameraState();
  }
}
class CameraState extends State<profPic>{
  File image;
  picker() async {
    print('picker is called');
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    image = img;
    print(img.path);
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title : new Text("Add Profile Picture"),
      ),
      body: Column(
        children: <Widget> [
          Padding(
            padding: EdgeInsets.all(20.0),
          ),
          ClipOval(
          child: image == null ?new Text(""):Image.file(image),
        ),
    new RaisedButton(
    onPressed: picker,
    child: new Icon(Icons.camera_alt)),

        ]),
      /*floatingActionButton: new FloatingActionButton
        (onPressed: picker,
          child: new Icon(Icons.camera_alt)),*/
    );

  }
}