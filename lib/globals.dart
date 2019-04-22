library UDriveTest.globals;
import 'services/crud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart'
;
bool registeredSuccessfully;
bool loggedSuccessfully;
String _userID = '';
String fname = "";
String lname = "";
String email = "";
String address = "";

crudMethods crudObj = new crudMethods();

Email sendEmail(String r1) {
  List<String> r = [r1];
  Email email = Email(
    body: 'Looks like we got something in common, want to chat?',
    subject: 'Hey Buddy, its $fname',
    recipients: r,
    cc: null,
    bcc: null,
    attachmentPath: null,
  );
  return email;
}



DateTime convertDateFromString(String strDate){
  DateTime todayDate = DateTime.parse(strDate);
  //print(todayDate);
  return todayDate;
  //print(formatDate(todayDate, [yyyy, '/', mm, '/', dd, ' ', hh, ':', nn, ':', ss, ' ', am]));
}

int diff_dates(String date) {
  final current_date = DateTime.now();
  final ride_date = convertDateFromString(date);
  return current_date.difference(ride_date).inDays;
}


String formatDate(date)
{
  return (date.substring(5,7) + "/" + date.substring(8,10) + "/" + date.substring(0, 4));
}

String formatTime(time)
{
  String AMorPM;
  String minute = time.substring(13,15);
  String hour = time.substring(10,12);
  if(int.parse(hour) < 12)
    AMorPM = "am";
  else if(int.parse(hour) > 12) {
    AMorPM = "pm";
    int hourNum = int.parse(hour);
    hourNum = hourNum - 12;
    hour = hourNum.toString();
  }
  else
    {
      AMorPM = "pm";
      int hourNum = int.parse(hour);
      hour = hourNum.toString();

    }
  return (hour + ":" + minute + AMorPM);
}


void set_userID(String uid)
{
  _userID = uid;
}
String get_userID()
{
  return _userID;
}

void getFname() async {
  await crudObj.getFname(get_userID());
}

void getLname() async {
  await crudObj.getLname(get_userID());
}
void getAddress() async {
  await crudObj.getAddress(get_userID());
}
void getEmail() async {
  await crudObj.getEmail(get_userID());
}

var UserModes = ['Rider', 'Driver', 'Driver/Rider'];
var currentItemSelected = UserModes[0];

var Login_Errors = ['ERROR_INVALID_EMAIL', 'ERROR_WRONG_PASSWORD', 'ERROR_USER_NOT_FOUND', 'ERROR_USER_DISABLED','ERROR_OPERATION_NOT_ALLOWED'];
var Login_Messages = [
  'The email address is malformed',
  'The password is wrong',
  'User could not be found',
  'The user has been disabled',
  'Too many attempts to sign in as this user, please try later'
];
var Register_Errors = ['ERROR_WEAK_PASSWORD', 'ERROR_INVALID_EMAIL', 'ERROR_EMAIL_ALREADY_IN_USE'];
var Register_Messages = [
  'Please try a stronger password',
  'The email address is malformed',
  'This email address is already in use'
];
var Forget_Errors = ['ERROR_INVALID_EMAIL', 'ERROR_USER_NOT_FOUND'];
var Forget_Messages = [
  'The email address is malformed',
  'No user corresponds to that email address'
];