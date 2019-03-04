import 'package:flutter/material.dart';

class Calendar extends StatefulWidget{
  @override
  _Calendar createState() => new _Calendar();
}

class _Calendar extends State<Calendar>{
    DateTime _date = new DateTime.now();
    TimeOfDay _startTime = new TimeOfDay.now();
    TimeOfDay _endTime = new TimeOfDay.now();
    String _address;

    void _selectDate(BuildContext context) async{
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: _date,
          firstDate: new DateTime(DateTime.now().year),
          lastDate: new DateTime(2020)
      );
      if(picked != null){
        print('Date selected:  ${_date.toString()}');
        setState(() {
          _date = picked;
        });
      }
    }

    Future<Null> _selectStartInterval(BuildContext context) async{
      final DateTime picked = (await showTimePicker(
          context: context,
          initialTime: _startTime
      )) as DateTime;
      if(picked != null && picked != _date){
        print('Time selected:  ${_startTime.toString()}');
        setState(() {
          _startTime = picked as TimeOfDay;
        });
      }
    }

    Future<Null> _selectEndInterval(BuildContext context) async{
      final DateTime picked = (await showTimePicker(
          context: context,
          initialTime: _endTime
      )) as DateTime;
      if(picked != null && picked != _date){
        print('Time selected:  ${_endTime.toString()}');
        setState(() {
          _endTime = picked as TimeOfDay;
        });
      }
    }

    @override
    Widget build(BuildContext context){
      return new Scaffold(
        body: new Container(
          padding: new EdgeInsets.all(32.0),
          child: new Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
              ),
              new RaisedButton(
                child: new Text('Select Date'),
                onPressed: (){
                  _selectDate(context);
                  },
              ),
              new RaisedButton(
                child: new Text('Select Start Time'),
                onPressed: (){_selectStartInterval(context);},
              ),
              new RaisedButton(
                child: new Text('Select End Time'),
                onPressed: (){_selectEndInterval(context);},
              ),
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Address'),
                validator: (value) => value.isEmpty ? 'Address can\'t be empty' : null,
              ),
              new RaisedButton(
                child: new Text('Submit Ride'),
                onPressed: (){_selectDate(context);},
              ),
            ],
          ),
        ),
      );
    }
}