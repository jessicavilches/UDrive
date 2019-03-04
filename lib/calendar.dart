import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'services/crud.dart';


class Calendar extends StatefulWidget{
  @override
  _Calendar createState() => new _Calendar();
}

class _Calendar extends State<Calendar>{
    DateTime _date = new DateTime.now();
    TimeOfDay _startTime = new TimeOfDay.now();
    TimeOfDay _endTime = new TimeOfDay.now();
    String _address;
    crudMethods crudObj = new crudMethods();

    void _selectDate(BuildContext context) async{
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: _date,
          firstDate: new DateTime(DateTime.now().year),
          lastDate: new DateTime(2020)
      );
      if(picked != null){
        setState(() {
          _date = picked;
        });
        print('Date selected:  ${_date.toString()}');
      }
    }

    Future<Null> _selectStartInterval(BuildContext context) async{
      final TimeOfDay picked = (await showTimePicker(
          context: context,
          initialTime: _startTime
      )); //as DateTime;
      if(picked != null){
        setState(() {
          _startTime = picked;
        });
        print('Time selected:  ${_startTime.toString()}');

      }
    }

    Future<Null> _selectEndInterval(BuildContext context) async{
      final TimeOfDay picked = (await showTimePicker(
          context: context,
          initialTime: _endTime
      ));
      if(picked != null){
        setState(() {
          _endTime = picked;
        });
        print('Time selected:  ${_endTime.toString()}');

      }
    }

    @override
    Widget build(BuildContext context){
      return new Scaffold(
        body: new Container(
          padding: EdgeInsets.all(32.0),
            child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            SizedBox(height: 100),
              new RaisedButton(
                child: new Text('Select Date'),
                onPressed: (){
                  _selectDate(context);
                  },
              ),
              SizedBox(height: 20),
              new RaisedButton(
                child: new Text('Select Start Time'),
                onPressed: (){_selectStartInterval(context);},
              ),
              SizedBox(height: 20),
              new RaisedButton(
                child: new Text('Select End Time'),
                onPressed: (){_selectEndInterval(context);},
              ),
              SizedBox(height: 20),
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Address'),
                validator: (value) => value.isEmpty ? 'Address can\'t be empty' : null,
              ),
              SizedBox(height: 10),
              new RaisedButton(
                child: new Text('Submit Ride'),
                onPressed: (){//_selectDate(context);
                addToDatabase();},
              ),
            ],
          ),
          ),
      );
    }


    void addToDatabase() async {
      //if(globals.registeredSuccessfully == true) {
        Map <String, dynamic> rideData = {
          'date': this._date.toString(),
          'start_time': this._startTime.toString(),
          'end_time': this._endTime.toString(),
          'address': this._address.toString(),
          //'uid' : this._userID
        };
        crudObj.addRide(rideData).catchError((e) {
          print(e);
        });
       // moveToLogin(); This should clear all values and let you submit a new ride
      //}
    }
}