import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'services/crud.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpcomingRides extends StatefulWidget{
  @override
  _UpcomingRides createState() => new _UpcomingRides();
}

class _UpcomingRides extends State<UpcomingRides> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //return new Scaffold(
      // appBar: new AppBar(
      //   title: new Text('Pool Feed')
      // ),
        child: ListPage()
      //);
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  Future _data;
  List<DocumentSnapshot> documentList = new List();


  Future getPosts() async {
    int i = 0;
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('RideCatalog').getDocuments(); // move to crud
    await qn.documents.forEach((DocumentSnapshot document) {
      //print("testing if date conversion function works:");
      //print(diff_dates('2019-03-05 00:00:00.000'));
      if((document.data['status'] == "Accepted"))// & (diff_dates(document.data['date'])>0))
          {
        if (globals.diff_dates(document.data['date'])<0) {
          print(globals.diff_dates(document.data['date']));
          /// add in "if" statement to check if date is after today
          //print(document.data['start_address']);
          //print(i);
          documentList.insert(i, document);
          i++;
          print("got here");
        }}
    });
    //return qn.documents;
    return documentList.cast<dynamic>();
  }

  navigateToDetail(DocumentSnapshot ride){
    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(ride: ride,)));
  }

  @override
  initState() {

    super.initState();
    _data = getPosts();
  }

  void launchMap(String startAddress, String endAddress, String midPoint) async{
    const double lat = 2.813812,  long = 101.503413;
    const String map_api= "1";
    //const url = "https://maps.google.com/maps/search/?api=$map_api&query=$lat,$long";
    String part1 = 'https://www.google.com/maps/dir/?api=1&origin=';
    String startA = startAddress.replaceAll(' ', '+');
    String part2 = '&waypoints=';
    String midpoint = midPoint.replaceAll(' ', '+');
    String part3 = '&destination=';
    String endA = endAddress.replaceAll(' ', '+');
    String part5 = '&travelmode=driving';
    String part6 = '&dir_action=navigate';
    print(midPoint);

    String url2 = part1+startA+part2+midpoint+part3+endA+part5+part6;
    //const url3 = url2.;

    const url = 'https://www.google.com/maps/dir/?api=1&origin=16350+SW+45th+Terr+Miami+FL+33185&waypoints=6861+SW+44th+St+Miami+FL&destination=1320+S+Dixie+Hwy+Coral+Gables+FL&travelmode=driving';
    //const url = 'https://www.google.com/maps/dir/?api=1&origin=Space+Needle+Seattle+WA&destination=Pike+Place+Market+Seattle+WA&travelmode=bicycling';

    if (await canLaunch(url2)) {
      print("Can launch");
      void initState(){
        super.initState();

        canLaunch( "https://maps.google.com/maps/search/?api=$map_api&query=$lat,$long");
      }

      await launch(url2);
    } else {
      print("Could not launch");
      throw 'Could not launch Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _data,
          builder: (_,snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Loading...'),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    print("this is the index");
                    print(index);
                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                              '\nDate: ' + globals.formatDate(snapshot.data[index].data["date"]) +
                                  '\n'),
                          Text('Driver\'s Name: ' +
                              snapshot.data[index].data["driver_name"]),
                          Text('Rider\'s Name: ' +
                              snapshot.data[index].data["rider_name"]),
                          Text('Ride Amount: \$' +
                              snapshot.data[index].data["bid_amount"]),
                          Text('Start Address: ' +
                              snapshot.data[index].data["start_address"]),
                          Text('End Address: ' +
                              snapshot.data[index].data["end_address"]),
                          Text('Start Time: ' +
                              globals.formatTime(snapshot.data[index].data["start_time"])),
                          Text('End Time: ' +
                              globals.formatTime(snapshot.data[index].data["end_time"])),
                          ButtonTheme
                              .bar( // make buttons use the appropriate styles for cards
                            child: ButtonBar(
                              children: <Widget>[
                                FlatButton(
                                  child: const Text('Navigate'),
                                  onPressed: () =>
                                      launchMap(snapshot.data[index].data["start_address"], snapshot.data[index].data["end_address"], snapshot.data[index].data["mid_address"]),
                                      //navigateToDetail(snapshot.data[index]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
          }),
    );
  }
}


class DetailPage extends StatefulWidget {
  final DocumentSnapshot ride;
  DetailPage({this.ride});
  @override
  _DetailPageState createState() => _DetailPageState();
}
class _DetailPageState extends State<DetailPage>{
  final formKey = new GlobalKey<FormState>();
  crudMethods crudObj = new crudMethods();

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold (
      appBar: AppBar(
        title: Text(globals.formatDate(widget.ride.data["date"])),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        child: Card(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('\nDate: '+ globals.formatDate(widget.ride.data["date"]) + '\n'),
                Text('Start Address: ' + widget.ride.data["start_address"]),
                Text('End Address: '+ widget.ride.data["end_address"]),
                Text('Start Time: ' + globals.formatTime(widget.ride.data["start_time"])),
                Text('End Time: ' + globals.formatTime(widget.ride.data["end_time"])),
              ]
          ),
        ),
      ),
    );
  }

}












