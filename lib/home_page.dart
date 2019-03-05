import 'package:flutter/material.dart';
import 'auth.dart';
import 'calendar.dart';
import 'feed.dart';

class HomePage extends StatefulWidget{
  HomePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

 @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  int currentTab = 0;
  Calendar calendar;
  Feed feed;

  List<Widget> pages;
  Widget currentPage;


  @override
  void initState(){
    calendar = Calendar();
    feed = Feed();
    currentPage = calendar;

    pages = [calendar,feed];

    super.initState();
  }

  void moveToFeed()
  {
    setState(() {
      currentPage = feed;
      currentTab = 1;
    });

  }

  void _signOut() async
  {
    try{
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Welcome', style: new TextStyle(fontSize: 20.0)),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Logout', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: _signOut,
          )
        ]
      ),
      body: currentPage,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (int index){
          setState(() {
              //print(index);
              currentTab = index;
              currentPage = calendar;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: new IconButton(
              icon: new Icon(Icons.calendar_today),
              iconSize: 40,
            ),
            title: Text('Create Ride'),
          ),
          BottomNavigationBarItem(
            icon: new IconButton(
                icon: new Icon(Icons.local_taxi),
                iconSize: 40,
                onPressed: moveToFeed
            ),
            title: Text('Feed'),
          ),
          BottomNavigationBarItem(
            icon: new IconButton(
                icon: new Icon(Icons.settings),
                iconSize: 40,
                onPressed: null
            ),
            title: Text('Settings'),

          ),
          BottomNavigationBarItem(
            icon: new IconButton(
                icon: new Icon(Icons.local_taxi),
                iconSize: 40,
                onPressed: null
            ),
            title: Text('Ride History'),
          ),
          BottomNavigationBarItem(
            icon: new IconButton(
                icon: new Icon(Icons.home),
                iconSize: 40,
                onPressed: null
            ),
            title: Text('Home'),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.pink,
      ),
    );
  }
}