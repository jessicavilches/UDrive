import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'services/crud.dart';
import 'dart:async';

class PendingRides extends StatefulWidget{
  @override
  _PendingRides createState() => new _PendingRides();
}

class _PendingRides extends State<PendingRides> {
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
      if((document.data['status'] == "Pending"))// & (diff_dates(document.data['date'])>0))
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
                      elevation: 8.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                              '\nDate: ' + globals.formatDate(snapshot.data[index].data["date"]) +
                                  '\n', style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5)),
                          Text('Start Address: ' +
                              snapshot.data[index].data["start_address"], style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5)),
                          Text('End Address: ' +
                              snapshot.data[index].data["end_address"], style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5)),
                          Text('Start Time: ' +
                              globals.formatTime(snapshot.data[index].data["start_time"]), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5)),
                          Text('End Time: ' +
                              globals.formatTime(snapshot.data[index].data["end_time"]), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5)),
                          ButtonTheme
                              .bar( // make buttons use the appropriate styles for cards
                            child: ButtonBar(
                              children: <Widget>[
                                FlatButton(
                                  child: const Text('View'),
                                  onPressed: () =>
                                      navigateToDetail(snapshot.data[index]),
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
                ButtonTheme.bar(
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('Accept'),
                        onPressed: () => updateDatabase("Accepted", widget.ride.documentID),
                      ),
                      FlatButton(
                        child: const Text("Decline"),
                        onPressed: () => updateDatabase("Declined", widget.ride.documentID),
                      )
                    ],
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }


  void updateDatabase(String choice, String docID) async {
    //if(validateAndSave()) {
    Map <String, dynamic> rideCatalog = {
      'date': widget.ride.data["date"],
      'start_time': widget.ride.data["start_time"],
      'end_time': widget.ride.data["end_time"],
      'start_address': widget.ride.data["start_address"],
      'end_address': widget.ride.data["end_address"],
      'mid_address': widget.ride.data["mid_address"],
      'rider_id': widget.ride.data["rider_id"],
      'driver_id': widget.ride.data["driver_id"],
      'driver_name': widget.ride.data["driver_name"],
      'rider_name': widget.ride.data["rider_name"],
      'arrival_time':widget.ride.data["arrival_time"],
      'bid_amount': widget.ride.data["bid_amount"],
      'status': choice,

    };
    Firestore.instance.collection("RideCatalog").document(docID).setData(rideCatalog).catchError((e) {
      print(e);
    });
    //}
    // moveToLogin(); This should clear all values and let you submit a new ride
    //}
  }

}












