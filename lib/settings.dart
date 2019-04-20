import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'services/crud.dart';
import 'dart:async';

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

  crudMethods crudObj = new crudMethods();

  Widget build(BuildContext context) {
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

  List<Widget> buildSubmitButtons() {
    return [
      new RaisedButton(
          child: new Text('Update/Add Payment', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          color: Colors.lightBlueAccent
      ),
      new Text("\n\n"),
      new RaisedButton(
        child: new Text('Save', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
        onPressed: () {
          validateAndSubmit();

          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: const Text('Your changes were successfully recorded'),
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
      form.save();
    print('this is the fname:');
    print(globals.fname);
    print('this is the lname:');
    print(globals.lname);
    print('this is the address:');
    print(globals.address);
    await addToDatabase();
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
        onSaved: (value) => _fname = value,
      ),
      new TextFormField(
        initialValue: globals.lname,
        decoration: new InputDecoration(labelText: 'Last Name'),
        validator: (value) => value.isEmpty ? 'Last name can\'t be empty' : null,
        onSaved: (value) => _lname = value,
      ),
      new TextFormField(
        initialValue: globals.mode,
        decoration: new InputDecoration(labelText: 'Mode'),
        validator: (value) => value.isEmpty ? 'Mode can\'t be empty' : null,
        onSaved: (value) => _mode = value,
      ),
      new TextFormField(
        initialValue: globals.address,
        decoration: new InputDecoration(labelText: 'Address'),
        validator: (value) => value.isEmpty ? 'Address can\'t be empty' : null,
        onSaved: (value) => _address = value,
      ),
      new Text('\nFormat: Street Address City State Abbreviation ZipCode'),
      new Text('Example: 1320 S Dixie Hwy Coral Gables FL 33146 \n \n '),
    ];
  }


  void addToDatabase() async {
    print('at this point this is fname:');
    print(this._fname);
    Map<String, dynamic> userData = {
    'fname': this._fname,
    'lname': this._lname,
    'mode': this._mode,
    'address' : this._address,
    'uid' : globals.get_userID()
    };
    crudObj.addData(userData).catchError((e) {
      print(e);
    });
  }

}