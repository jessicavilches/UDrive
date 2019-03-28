import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'services/crud.dart';
import 'dart:async';
import 'past_rides.dart' as past;
import 'upcoming_rides.dart' as upcoming;
import 'pending_rides.dart' as pending;

class Rides extends StatefulWidget{
  @override
  _Rides createState() => new _Rides();
}

class _Rides extends State<Rides> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 3);
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
        title: new Text("Rides"),
        backgroundColor: Colors.grey,
        bottom: new TabBar(
            controller: controller,
            tabs: <Text>[
                new Text("Past"),
                new Text("Upcoming"),
                new Text("Pending"),
            ]
        )
        ),
      body: new TabBarView(
        controller: controller,
        children: <Widget> [
          new past.PastRides(),
          //new upcoming.UpcomingRides(),
          //new pending.PendingRides()
        ]
      )
    );
  }
}

