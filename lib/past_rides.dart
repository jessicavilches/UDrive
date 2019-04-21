import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'services/crud.dart';
import 'dart:async';

class PastRides extends StatefulWidget{
  @override
  _PastRides createState() => new _PastRides();
}

class _PastRides extends State<PastRides> {
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
        if (globals.diff_dates(document.data['date'])>0) {
        print(globals.diff_dates(document.data['date']));
        ////// add in "if" statement to check if the ID matches
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
                        //mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment:  CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '\nDate: ' + globals.formatDate(snapshot.data[index].data["date"]) +
                                '\n', style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2)),
                          Text('Driver\'s Name: ' +
                              snapshot.data[index].data["driver_name"], style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2)),
                          Text('Rider\'s Name: ' +
                              snapshot.data[index].data["rider_name"], style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2)),
                          Text('Ride Amount: \$' +
                              snapshot.data[index].data["bid_amount"], style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2)),

                          Text('Start Address: ' +
                              snapshot.data[index].data["start_address"], style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2)),
                          Text('End Address: ' +
                              snapshot.data[index].data["end_address"], style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2)),
                          Text('Start Time: ' +
                              globals.formatTime(snapshot.data[index].data["start_time"]), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2)),
                          Text('End Time: ' +
                              globals.formatTime(snapshot.data[index].data["end_time"]), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2)),
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
          elevation: 8.0,
          child: ListView(
              padding: EdgeInsets.all(25.0),
              children: <Widget>[
                Text('\nDate: '+ globals.formatDate(widget.ride.data["date"]) + '\n', style: TextStyle(fontSize: 20.0),),
                Text('Driver\'s Name: ' + widget.ride.data["driver_name"], style: TextStyle(fontSize: 20.0)),
                Text('Rider\'s Name: ' + widget.ride.data["rider_name"], style: TextStyle(fontSize: 20.0)),
                Text('Ride Amount: \$' + widget.ride.data["bid_amount"], style: TextStyle(fontSize: 20.0)),
                Text('Start Address: ' + widget.ride.data["start_address"], style: TextStyle(fontSize: 20.0)),
                Text('End Address: '+ widget.ride.data["end_address"], style: TextStyle(fontSize: 20.0)),
                Text('Start Time: ' + globals.formatTime(widget.ride.data["start_time"]), style: TextStyle(fontSize: 20.0)),
                Text('End Time: ' + globals.formatTime(widget.ride.data["end_time"]), style: TextStyle(fontSize: 20.0)),
              ]
          ),
        ),
      ),
    );
  }

}












