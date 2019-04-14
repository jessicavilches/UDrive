import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapSample extends StatefulWidget {

  @override
  ListState createState() {
    return new ListState();
  }
}

class ListState extends State<MapSample> {

  static const double lat = 2.813812,  long = 101.503413;
  static const String map_api= "1";

  @override
  Widget build(BuildContext context) {

    //method to launch maps
    void launchMap() async{
      const url = "https://maps.google.com/maps/search/?api=$map_api&query=$lat,$long";
     if (await canLaunch(url)) {
        print("Can launch");
        void initState(){
          super.initState();

          canLaunch( "https://maps.google.com/maps/search/?api=$map_api&query=$lat,$long");
        }

        await launch(url);
      } else {
        print("Could not launch");
        throw 'Could not launch Maps';
      }
    }

    //method to bring out dialog
    void makeDialog(){
      showDialog(
          context: context,
          builder: (_) => new SimpleDialog(
            contentPadding: EdgeInsets.only(left: 30.0, top: 30.0),
            children: <Widget>[
              new Text("Address: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              new ButtonBar(
                children: <Widget>[
                  new IconButton(
                      icon: Icon(Icons.close),
                      onPressed: (){
                        Navigator.pop(context);
                      }
                  )
                ],
              )
            ],
          )
      );
    }

    return new Scaffold(
      body: new ListView.builder(
        itemBuilder: (context, index) => ExpansionTile(
          title: new Text("State ${index+1}"),
          children: <Widget>[
            new ListTile(
              title: new Text("Place 1"),
              trailing: new Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new IconButton(
                      icon: Icon(Icons.info),
                      onPressed: makeDialog
                  ),
                  new IconButton(
                      icon: Icon(Icons.directions),
                      onPressed: launchMap
                  )
                ],
              ),
            ),
            new Divider(height: 10.0),
            new ListTile(
              title: new Text("Place 2"),
              trailing: new Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new IconButton(
                      icon: Icon(Icons.info),
                      onPressed: makeDialog
                  ),
                  new IconButton(
                      icon: Icon(Icons.directions),
                      onPressed: launchMap
                  )
                ],
              ),
            )
          ],
        ),
        itemCount: 5,
      ),
    );
  }
}



/*

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//void main() => runApp(MyApp());
/*
class Mapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}
*/
class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context);
        },
        label: Text('Back to Ride Info'),
        icon: Icon(Icons.contacts),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

*/