import 'package:flutter/material.dart';
import 'login_page.dart';
import 'auth.dart';
import 'home.dart';
import 'root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UDrive',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      //home: HomePage(),
      home: new LoginPage(auth: new Auth()),
      routes: <String, WidgetBuilder> {
        '/homepage': (BuildContext context) => new HomePage(),
        '/login': (BuildContext context) => new LoginPage(),
      }
      //home: new RootPage(auth: new Auth()),
    );
  }
}

