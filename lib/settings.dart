import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'services/crud.dart';
import 'dart:async';
import 'package:stripe_payment/stripe_payment.dart';
import'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';




class Settings extends StatefulWidget{
  @override
  _Settings createState() => new _Settings();
}

class _Settings extends State<Settings>{

  final formKey = new GlobalKey<FormState>();
  String _fname;
  String _lname;
  String _mode;
  String _address;
  File image;
  Image image2;
  var img;
  String downloadURL;
  crudMethods crudObj = new crudMethods();

  Future downloadImage(String uid) async {
    print("HERE1");
    final StorageReference firebaseStorageRef = await
    FirebaseStorage.instance.ref().child(uid);
    print("HERE2");
    String downloadAddress;
    print("HERE3");
    downloadAddress = await firebaseStorageRef.getDownloadURL();
    print("HERE4");
    downloadURL = await downloadAddress;
    print("at this point: ");
    print(downloadURL);
    await setState(() {
      downloadURL = downloadAddress;
      print("did i set up downloaduRL");
      print(downloadURL);
    });
    // return downloadURL;
  }
  Future<void> grabImage() async
  {
    await downloadImage(globals.get_userID());
  }

  initState() {
    super.initState();
    //downloadImage(globals.get_userID());
    grabImage();
    //image2 =  Image.network(downloadURL);

  }
  picker() async {
    print('picker is called');
    img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState ( (){
      image = img;
      //image2 = Image.file(img);
    });
  }

  Widget build(BuildContext context) {
    print("building");
    print(downloadURL);
    if(downloadURL == null)
      {
        print("null");
        return(
        Center(
          child: Text("Loading"),)
        );
      }
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new ListView(
            children: buildInputs() + buildSubmitButtons(),
          )
        )
      )
    );
  }
  void _addSource(String token) {
    print("Token => $token");
  }
  List<Widget> buildSubmitButtons() {
    return [
      new RaisedButton(
          child: new Text('Update/Add Payment', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          color: Colors.lightBlueAccent,
        onPressed: () {
          StripeSource.addSource().then((String token) {
            _addSource(token);
          });
        }
      ),
      new Text("\nAdd Profile Picture:"),
      Column(
          children: <Widget> [
            Padding(
              padding: EdgeInsets.all(20.0),
            ),
            Container(
              width: 100,
                height: 100,
                child: ClipOval(
              child: image == null ? Image.network(downloadURL): Image.file(image), //Image.file(image),
            )),
            new RaisedButton(
                onPressed: picker,
                child: new Icon(Icons.camera_alt)),
          ]),
      new Text("\n\n"),
      new RaisedButton(
        child: new Text('Save', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
        onPressed: () {
          validateAndSubmit().then((_){ addToDatabase();
          });

         /* if(image != null)
          {
            print("SAVED IMAGE");
            final StorageReference firebaseStorageRef =
            FirebaseStorage.instance.ref().child(globals.get_userID());
            final StorageUploadTask task = firebaseStorageRef.putFile(image);}
*/
          image = img;


          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: const Text('Your changes were successfully recorded, if you updated you profile picture, please allow 5 minutes for changes to take effect'),
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

        },
          color: Colors.blueGrey
      ),
    ];
  }

  Future<void> validateAndSubmit() async {
    final form = formKey.currentState;
    if (form.validate()) {
      await form.save();
    print('this is the fname:');
    print(_fname);
    print('this is the lname:');
    //print(_lname);
    print('this is the address:');
    //print(_address);
    //////await addToDatabase();
     /* if(image != null)
      {
        print("SAVED IMAGE");
        final StorageReference firebaseStorageRef =
        await FirebaseStorage.instance.ref().child(globals.get_userID());
        final StorageUploadTask task = await firebaseStorageRef.putFile(image);} */
    }
    else {
      print("form couldn't be validated");
    }
  }

  List<Widget> buildInputs() {
    final _myPassController = TextEditingController();
    //this._mode = globals.currentItemSelected;
    return [
      new TextFormField(
        initialValue: globals.fname,
        decoration: new InputDecoration(labelText: 'First Name'),
        validator: (value) => value.isEmpty ? 'First name can\'t be empty' : null,
        onSaved: (value) { _fname = value; globals.fname= value; },
      ),
      new TextFormField(
        initialValue: globals.lname,
        decoration: new InputDecoration(labelText: 'Last Name'),
        validator: (value) => value.isEmpty ? 'Last name can\'t be empty' : null,
        //onSaved: (value) => _lname = value,
        onSaved: (value) { _lname = value; globals.lname= value; },
      ),
      /*new TextFormField(
        initialValue: globals.mode,
        decoration: new InputDecoration(labelText: 'Mode'),
        validator: (value) => value.isEmpty ? 'Mode can\'t be empty' : null,
        onSaved: (value) => _mode = value,
      ),*/
      new TextFormField(
        initialValue: globals.address,
        decoration: new InputDecoration(labelText: 'Address'),
        validator: (value) => value.isEmpty ? 'Address can\'t be empty' : null,
        //onSaved: (value) => _address = value,
        onSaved: (value) { _address = value; globals.address= value; },
      ),
      new Text('\nFormat: Street Address City State Abbreviation ZipCode'),
      new Text('Example: 1320 S Dixie Hwy Coral Gables FL 33146 \n \n '),
    ];
  }


  void addToDatabase() async {
    print('at this point this is fname:');
    //print(this._fname);
    Map<String, dynamic> userData = {
    'fname': this._fname,
    'lname': this._lname,
    'address' : this._address,
      //'fname2': globals.fname,
      //'lname2': globals.lname,
      //'address2' : globals.address,
    'uid' : globals.get_userID(),
      'email': globals.email,
    };
    await crudObj.addData(userData).catchError((e) {
      print(e);
    });

    if(image != null)
    {
      print("SAVED IMAGE");
      final StorageReference firebaseStorageRef =
      await FirebaseStorage.instance.ref().child(globals.get_userID());
      final StorageUploadTask task = await firebaseStorageRef.putFile(image);}

  }

}