import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'services/crud.dart';
import 'dart:async';

class Settings extends StatefulWidget{
  @override
  _Settings createState() => new _Settings();
}

class _Settings extends State<Settings> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: new AppBar(
        title: new Text('Settings', style: new TextStyle(fontSize: 20.0)),
    ),
    );
  }
}