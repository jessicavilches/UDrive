import 'package:flutter/material.dart';
import 'auth.dart';
import 'calendar.dart';
import 'feed.dart';
import 'rides.dart';
import 'settings.dart';
import 'globals.dart' as globals;

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
  Settings settings;
  Rides rides;

  List<Widget> pages;
  Widget currentPage;


  @override
  void initState(){
    calendar = Calendar();
    feed = Feed();
    rides = Rides();
    settings = Settings();
    currentPage = calendar;
    currentTab = 0;
    pages = [calendar,feed, rides, settings];

    super.initState();
  }

  void moveToFeed()
  {
    setState(() {
      currentPage = feed;
      currentTab = 1;
    });

  }
  void moveToCalendar()
  {
    setState(() {
      currentPage = calendar;
      currentTab = 0;
    });

  }

  void moveToRides()
  {
    setState(() {
      currentPage = rides;
      currentTab = 2;
    });
  }
      Future <void> moveToSettings() async {
    await globals.getFname();
    await globals.getLname();
    await globals.getAddress();
    await globals.getMode();

    setState(() {
      currentPage = settings;
      currentTab = 3;
    });
      }

  void _signOut() async
  {
    try{
      await widget.auth.signOut();
      widget.onSignedOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print(e);
      Navigator.of(context).pushReplacementNamed('/login');
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
              onPressed: moveToCalendar,
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
          ),BottomNavigationBarItem(
            icon: new IconButton(
                icon: new Icon(Icons.local_taxi),
                iconSize: 40,
                onPressed: moveToRides
            ),
            title: Text('Ride History'),
          ),
          BottomNavigationBarItem(
            icon: new IconButton(
                icon: new Icon(Icons.settings),
                iconSize: 40,
                onPressed: moveToSettings,
            ),
            title: Text('Settings'),
          ),

        ],
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.pink,
      ),
    );
  }
}