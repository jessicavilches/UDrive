library UDriveTest.globals;
import 'services/crud.dart';

bool registeredSuccessfully;
bool loggedSuccessfully;
String _userID = 'FkWddb7FPjXz7Q4O3nnAlkx56wz2';
String fname = "";
String lname = "";
String mode = "";
String address = "";

crudMethods crudObj = new crudMethods();

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
  else{
    AMorPM = "pm";
    int hourNum = int.parse(hour);
    hourNum = hourNum - 12;
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
void getMode() async {
  await crudObj.getMode(get_userID());
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