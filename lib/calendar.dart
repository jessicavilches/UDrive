import 'package:flutter/material.dart';

class Calendar extends StatefulWidget{
  @override
  _Calendar createState() => new _Calendar();
}

class _Calendar extends State<Calendar>{
    DateTime _date = new DateTime.now();
    TimeOfDay _time = new TimeOfDay.now();

    Future<Null> _selectDate(BuildContext context) async{
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: _date,
          firstDate: new DateTime(DateTime.now().year),
          lastDate: new DateTime(2019)
      );
      if(picked != null && picked != _date){
        print('Date selected:  ${_date.toString()}');
        setState(() {
          _date = picked;
        });
      }
    }

    @override
    Widget build(BuildContext context){
      print('Here');
      return new Scaffold(
        body: new Container(
          padding: new EdgeInsets.all(32.0),
          child: new Column(
            children: <Widget>[
              new Text ('Date selected: ${_date.toString()}'),
              new RaisedButton(
                child: new Text('Select Date'),
                onPressed: (){_selectDate(context);}
              ),
            ],
          ),
        ),
      );
    }
}