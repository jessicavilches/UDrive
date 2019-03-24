import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'services/crud.dart';
import 'dart:async';

class Feed extends StatefulWidget{
  @override
  _Feed createState() => new _Feed();
}

class _Feed extends State<Feed> {
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


  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('Rides').getDocuments(); // move to crud

    return qn.documents;
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
                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('\nDate: '+ snapshot.data[index].data["date"] + '\n'),
                          Text('Start Address: ' + snapshot.data[index].data["start_address"]),
                          Text('End Address: '+ snapshot.data[index].data["end_address"]),
                          Text('Start Time: ' + snapshot.data[index].data["start_time"]),
                          Text('End Time: ' + snapshot.data[index].data["end_time"]),
                          ButtonTheme.bar( // make buttons use the appropriate styles for cards
                            child: ButtonBar(
                              children: <Widget>[
                                FlatButton(
                                  child: const Text('View'),
                                  onPressed: () => navigateToDetail(snapshot.data[index]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );

                    /*return ListTile(
                      title: Text(snapshot.data[index].data["date"]), //sub in fname, lname etc
                      subtitle: Text(snapshot.data[index].data["start_address"]),
                      //subtitle: Text(snapshot.data[index].data["end_address"]),

                    );*/
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
        title: Text(widget.ride.data["date"]),
      ),
      body: Container(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('\nDate: '+ widget.ride.data["date"] + '\n'),
            Text('Start Address: ' + widget.ride.data["start_address"]),
            Text('End Address: '+ widget.ride.data["end_address"]),
            Text('Start Time: ' + widget.ride.data["start_time"]),
            Text('End Time: ' + widget.ride.data["end_time"]),
          ButtonTheme.bar( // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('Request Ride'),
                  onPressed: () => addToDatabase(),
                ),
              ],
            ),
          ),
          ]
        ),
      ),
    ),
    );
  }




  void addToDatabase() async {
    //if(validateAndSave()) {
      Map <String, dynamic> rideCatalog = {
        'date': widget.ride.data["date"],
        'start_time': widget.ride.data["start_time"],
        'end_time': widget.ride.data["end_time"],
        'start_address': widget.ride.data["start_address"],
        'end_address': widget.ride.data["end_address"],
        'rider_id' : globals.get_userID(),
        'driver_id' : widget.ride.data["uid"],
        'status' : "Pending",
      };
      crudObj.addRideCatalog(rideCatalog).catchError((e) {
        print(e);
      });
    //}
    // moveToLogin(); This should clear all values and let you submit a new ride
    //}
  }


}


