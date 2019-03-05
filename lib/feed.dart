import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'services/crud.dart';

class Feed extends StatefulWidget{
  @override
  _Feed createState() => new _Feed();
}

class _Feed extends State<Feed> {
  final formKey = new GlobalKey<FormState>();
  DateTime _date = new DateTime.now();
  TimeOfDay _startTime = new TimeOfDay.now();
  TimeOfDay _endTime = new TimeOfDay.now();
  String _startAddress;
  String _endAddress;
  crudMethods crudObj = new crudMethods();


  Widget _buildContent() {
    return ListView.builder(
      //itemCount: allContacts.length,
        itemBuilder: (BuildContext content, int index) {
          // Contact contact = allContacts[index];
          // return ContactListTile(contact);
        });
  }


  @override
  void initstate() {
    crudObj.getData().then((results) {

    });
  }

/*
  class ContactListTile extends ListTile {
  ContactListTile(Contact contact)
      : super(
  title: Text(contact.name),
  subtitle: Text(contact.email),
  leading: CircleAvatar(child: Text(contact.name[0])),
  );
  }*/

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(DateTime
            .now()
            .year),
        lastDate: new DateTime(2020)
    );
    if (picked != null) {
      setState(() {
        _date = picked;
      });
      print(' selected:  ${_date.toString()}');
    }
  }

  Future<Null> _selectStartInterval(BuildContext context) async {
    final TimeOfDay picked = (await showTimePicker(
        context: context,
        initialTime: _startTime
    )); //as DateTime;
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
      print('Time selected:  ${_startTime.toString()}');
    }
  }

  Future<Null> _selectEndInterval(BuildContext context) async {
    final TimeOfDay picked = (await showTimePicker(
        context: context,
        initialTime: _endTime
    ));
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
      print('Time selected:  ${_endTime.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
          padding: EdgeInsets.all(32.0),
          child: new Form(
            key: formKey,
            child: new ListView(
              children: <Widget>[
                SizedBox(height: 100),
                new RaisedButton(
                  child: new Text('FEED: ' + this._date.month.toString()
                      + '/' + this._date.day.toString() + '/' +
                      this._date.year.toString(),
                      style: new TextStyle(fontSize: 20.0)),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
                SizedBox(height: 20),
                new RaisedButton(
                  child: new Text(
                      'Select Start Time: ' + this._startTime.format(context),
                      style: new TextStyle(fontSize: 20.0)),
                  onPressed: () {
                    _selectStartInterval(context);
                  },
                ),
                SizedBox(height: 20),
                new RaisedButton(
                  child: new Text(
                      'Select End Time: ' + this._endTime.format(context),
                      style: new TextStyle(fontSize: 20.0)),
                  onPressed: () {
                    _selectEndInterval(context);
                  },
                ),
                SizedBox(height: 20),
                new TextFormField(
                  decoration: new InputDecoration(labelText: 'Start Address'),
                  validator: (value) =>
                  value.isEmpty
                      ? 'Start Address can\'t be empty'
                      : null,
                  onSaved: (value) => _startAddress = value,
                ),
                new TextFormField(
                  decoration: new InputDecoration(labelText: 'End Address'),
                  validator: (value) =>
                  value.isEmpty
                      ? 'Start Address can\'t be empty'
                      : null,
                  onSaved: (value) => _endAddress = value,
                ),
                SizedBox(height: 40),
                new RaisedButton(
                  child: new Text(
                      'Submit Ride', style: new TextStyle(fontSize: 20.0)),
                  onPressed: () { //_selectDate(context);
                    addToDatabase();
                  },
                ),
              ],
            ),
          )
      ),
    );
  }


  void addToDatabase() async {
    if (validateAndSave()) {
      Map <String, dynamic> rideData = {
        'date': this._date.toString(),
        'start_time': this._startTime.toString(),
        'end_time': this._endTime.toString(),
        'start_address': this._startAddress,
        'end_address': this._endAddress,
        'uid' : globals.get_userID()
      };
      crudObj.addRide(rideData).catchError((e) {
        print(e);
      });
    }
    // moveToLogin(); This should clear all values and let you submit a new ride
    //}
  }
}
