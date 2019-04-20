import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'services/crud.dart';
import 'dart:async';
import 'googleMaps.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';


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
  List<DocumentSnapshot> _data;
  //List<DocumentSnapshot> documentList = new List();
  List<Image> profPicslist = new List();
  List<String> uids = new List();
  String downloadURL;


  Future downloadImage(String uid) async {
    print("HERE1");
    final StorageReference firebaseStorageRef = await
    FirebaseStorage.instance.ref().child(uid);
    print("HERE2");
    String downloadAddress;
    print("HERE3");
    downloadAddress = await firebaseStorageRef.getDownloadURL();
    print("HERE4");
    downloadURL = downloadAddress;
    print("at this point: ");
    print(downloadURL);
    await setState(() {
      downloadURL = downloadAddress;
      print("did i set up downloaduRL");
      print(downloadURL);
    });
    // return downloadURL;
  }

  Future fillPicList() async
  {
    await getPosts();
    for (int i = 0; i < uids.length; i++) //String uid in uids)
        {
      print("DOWNLOAD IMAGE");
      await downloadImage(uids[i]);
      await profPicslist.insert(i, Image.network(downloadURL));
    }
    print("SET STATE");
    setState(() {});
  }

  getPosts() async {
    int i = 0;
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('Rides')
        .getDocuments(); // move to crud

    await qn.documents.forEach((DocumentSnapshot document) {
      print("did i do this");
      print(globals.diff_dates(document.data["date"]));
      if (globals.diff_dates(document.data["date"]) <= 0) {
        _data.insert(i, document);
        print(globals.diff_dates(document.data["date"]));

        uids.add(document.data["uid"]);
        /*downloadImage(document.data["uid"]);


        //print("DOWNLOAD URL: " + downloadURL); //downloadURL is null
        if(downloadURL == null){
          print("ITS NULL");
          profPicslist.insert(i,null);}
        else
          profPicslist.insert(i,Image.network(downloadURL));*/

        i++;
        //child: downloadURL == null ? Container(): Image.network(downloadURL)
      }
    });
    //return qn.documents;
  }

  navigateToDetail(DocumentSnapshot ride) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailPage(ride: ride,)));
  }


  @override
  initState() {
    super.initState();
    _data = new List();
    fillPicList();
  }

  void launchMap(String startAddress, String endAddress,
      String midPoint) async {
    const double lat = 2.813812,
        long = 101.503413;
    const String map_api = "1";
    //const url = "https://maps.google.com/maps/search/?api=$map_api&query=$lat,$long";
    String part1 = 'https://www.google.com/maps/dir/?api=1&origin=';
    String startA = startAddress.replaceAll(' ', '+');
    String part2 = '&waypoints=';
    String midpoint = midPoint.replaceAll(' ', '+');
    String part3 = '&destination=';
    String endA = endAddress.replaceAll(' ', '+');
    String part5 = '&travelmode=driving';
    print(midPoint);

    String url2 = part1 + startA + part2 + midpoint + part3 + endA + part5;
    //const url3 = url2.;

    const url = 'https://www.google.com/maps/dir/?api=1&origin=16350+SW+45th+Terr+Miami+FL+33185&waypoints=6861+SW+44th+St+Miami+FL&destination=1320+S+Dixie+Hwy+Coral+Gables+FL&travelmode=driving';
    //const url = 'https://www.google.com/maps/dir/?api=1&origin=Space+Needle+Seattle+WA&destination=Pike+Place+Market+Seattle+WA&travelmode=bicycling';

    if (await canLaunch(url2)) {
      print("Can launch");
      void initState() {
        super.initState();

        canLaunch(
            "https://maps.google.com/maps/search/?api=$map_api&query=$lat,$long");
      }

      await launch(url2);
    } else {
      print("Could not launch");
      throw 'Could not launch Maps';
    }
  }

  getProfPic(Image image) {
    return (
        Container(
            width: 150.0,
            height: 150.0,
            child: ClipOval(
              child: image == null ? Container() : image,
              /*profPicslist[index] == null ? Container(): profPicslist[index],*/
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    /*return Container(
      child: FutureBuilder(
          future: _data,
          builder: (_,snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Loading...'),
              );
            } else {*/
    return ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 8.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                getProfPic(profPicslist[index]),
                Text(
                    '\nDate: ' + globals.formatDate(_data[index].data["date"]) +
                        '\n', style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
                Text('Driver\'s name: ' + _data[index].data["driver_name"],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Text('Start Address: ' + _data[index].data["start_address"],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Text('End Address: ' + _data[index].data["end_address"],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Text('Start Time: ' +
                    globals.formatTime(_data[index].data["start_time"]),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Text('End Time: ' +
                    globals.formatTime(_data[index].data["end_time"]),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                ButtonTheme
                    .bar( // make buttons use the appropriate styles for cards

                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('View Ride'),
                        onPressed: () {
                          launchMap(_data[index].data["start_address"],
                              _data[index].data["end_address"],
                              globals.address);
                          print("tried doing map");
                        },
                      ),
                      FlatButton(
                        child: const Text('Request Ride'),
                        onPressed: () => navigateToDetail(_data[index]),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ); //}
        });
  }
}
            /*
          }),
    );
  }
}*/


class DetailPage extends StatefulWidget {
  final DocumentSnapshot ride;
  DetailPage({this.ride});
  @override
  _DetailPageState createState() => _DetailPageState();
}
class _DetailPageState extends State<DetailPage> {
  final formKey = new GlobalKey<FormState>();
  String amountToPay;
  TimeOfDay arrivalTime = new TimeOfDay.now();
  crudMethods crudObj = new crudMethods();

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void goToMaps() async
  {
    var url = 'https://www.google.com/maps/dir/?api=1&origin=Space+Needle+Seattle+WA&destination=Pike+Place+Market+Seattle+WA&travelmode=bicycling';
    var response = await http.post(url);
    //launch(url);
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    //print(await http.read('http://example.com/foobar.txt'));
  }

  Future<Null> _selectTime(BuildContext context) async{
    final TimeOfDay picked = (await showTimePicker(
        context: context,
        initialTime: arrivalTime
    )); //as DateTime;
    if(picked != null){
      setState(() {
        arrivalTime = picked;
      });
      print('Time selected:  ${arrivalTime.toString()}');

    }
  }

  List<Widget> buildInputs() {
    return [
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Ride bid'),
        validator: (value) => value.isEmpty ? 'Bid can\'t be empty' : null,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        onSaved: (value) => amountToPay = value,
      ),
      new RaisedButton(
        child: new Text('Select Arrival Time: ' + this.arrivalTime.format(context), style: new TextStyle(fontSize: 20.0)),
        onPressed: (){
          _selectTime(context);
        },
      )
    ];

  }

   String hash_Code() {
      int hash = 7;
      hash = 41 * hash + widget.ride.data["start_time"].hashCode;
      hash = 41 * hash + widget.ride.data["end_time"].hashCode;
      hash = 41 * hash + widget.ride.data["date"].hashCode;
      hash = 41 * hash + widget.ride.data["driver_id"].hashCode;
      hash = 41 * hash + widget.ride.data["rider_id"].hashCode;
      return hash.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ride.data["driver_name"]+'\'s ride'),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Card(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('\nDate: ' + globals.formatDate(widget.ride.data["date"]) +
                    '\n', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                Text('Start Address: ' + widget.ride.data["start_address"], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                Text('End Address: ' + widget.ride.data["end_address"], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                Text('Start Time: ' +
                    globals.formatTime(widget.ride.data["start_time"]), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                Text('End Time: ' +
                    globals.formatTime(widget.ride.data["end_time"]), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                new Form(
                  key: formKey,
                  child: new TextFormField(
                    decoration: new InputDecoration(labelText: 'Ride bid'),
                    validator: (value) => value.isEmpty ? 'Bid can\'t be empty' : null,
                    keyboardType: TextInputType.number,
                    onSaved: (value) => amountToPay = value,
          )
          ),
          SizedBox(height: 50),
          RaisedButton(
            color: Colors.blueGrey,
            child: new Text('Select Arrival Time: ' + this.arrivalTime.format(context), style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: (){
              _selectTime(context);
            },
          ),
               // child: buildInputs(),
                ButtonTheme
                    .bar( // make buttons use the appropriate styles for cards
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('Submit Request'),
                        onPressed: ()
                        {
                          final form = formKey.currentState;
                          form.save();
                          addToDatabase();

                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Success'),
                                content: const Text('Your request was successfully submitted'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }

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
      'mid_address': globals.address,
      'rider_id': globals.get_userID(),
      'driver_id': widget.ride.data["uid"],
      'driver_name': widget.ride.data["driver_name"],
      'rider_name': globals.fname,
      'arrival_time': this.arrivalTime.toString(),
      'bid_amount': this.amountToPay.toString(),
      'status': "Pending",
    };
    crudObj.addRideCatalog(rideCatalog, hash_Code()).catchError((e) {
      print(e);
    });
    //}
    // moveToLogin(); This should clear all values and let you submit a new ride
    //}
  }
}

