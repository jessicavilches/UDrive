import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'services/crud.dart';


class Calendar extends StatefulWidget{
  @override
  _Calendar createState() => new _Calendar();
}

class _Calendar extends State<Calendar>{
    final formKey = new GlobalKey<FormState>();
    DateTime _date = new DateTime.now();
    TimeOfDay _startTime = new TimeOfDay.now();
    TimeOfDay _endTime = new TimeOfDay.now();
    String _startAddress;
    String _endAddress;
    //String _uid;
    crudMethods crudObj = new crudMethods();

    bool validateAndSave() {
      final form = formKey.currentState;
      if (form.validate()){
        form.save();
        return true;
      }
      return false;
    }
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
            child: new Form(
              key: formKey,
            child: new ListView(
            children: <Widget>[
            SizedBox(height: 100),
              new RaisedButton(
                child: new Text('Select Date: '  + this._date.month.toString()
                    + '/' + this._date.day.toString() + '/' + this._date.year.toString(), style: new TextStyle(fontSize: 20.0, color: Colors.white),),
                onPressed: (){
                  _selectDate(context);
                  },
                color: Colors.blueGrey,
              ),
              SizedBox(height: 20),
              new RaisedButton(
                child: new Text('Select Start Time: ' + this._startTime.format(context), style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                onPressed: (){
                  _selectStartInterval(context);
                  },
                color: Colors.blueGrey,
              ),
              SizedBox(height: 20),
              new RaisedButton(
                child: new Text(
                  'Select End Time: ' + this._endTime.format(context), style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                onPressed: (){_selectEndInterval(context);},
                color: Colors.blueGrey,
              ),
              SizedBox(height: 20),
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Start Address'),
                validator: (value) => value.isEmpty ? 'Start Address can\'t be empty' : null,
                onSaved: (value) => _startAddress = value,
              ),
              new TextFormField(
              decoration: new InputDecoration(labelText: 'End Address'),
              validator: (value) => value.isEmpty ? 'Start Address can\'t be empty' : null,
              onSaved: (value) => _endAddress = value,
              ),
              //SizedBox(height: 40),
            new Text('\nFormat: Street Address City State Abbreviation ZipCode'),
            new Text('Example: 1320 S Dixie Hwy Coral Gables FL 33146 \n \n '),
            SizedBox(height: 20),
              new RaisedButton(
                child: new Text('Submit Ride', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                onPressed: (){//_selectDate(context);
                addToDatabase();

                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Success'),
                      content: const Text('Your ride was successfully submitted'),
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
                color: Colors.blueGrey,
              ),
            ],
          ),
            )
          ),
      );
    }


    void addToDatabase() async {
        if(validateAndSave()) {
          Map <String, dynamic> rideData = {
            'date': this._date.toString(),
            'start_time': this._startTime.toString(),
            'end_time': this._endTime.toString(),
            'start_address': this._startAddress,
            'end_address': this._endAddress,
            'driver_name': globals.fname,
            'uid' : globals.get_userID(),
            'driver_email': globals.email,
          };
          crudObj.addRide(rideData).catchError((e) {
            print(e);
          });
        }
        //globals.
        //globals.showD(context);
       // moveToLogin(); This should clear all values and let you submit a new ride
      //}
    }
}