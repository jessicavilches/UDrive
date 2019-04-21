import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'globals.dart' as globals;
import 'services/crud.dart';
import 'auth.dart';
import 'profilePic.dart';
import'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType {
  login,
  register,
  forget
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  String _fname;
  String _lname;
  String _email;
  String _password;
  String _address;
  FormType _formType = FormType.login;
  File image;

  static String filePath = 'images/UdriveLogo.png';
  File logoPic = new File(filePath);

  picker() async {
    print('picker is called');
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState ( (){
      image = img;
    });
  }

  crudMethods crudObj = new crudMethods();

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  void getFname() async {
    await crudObj.getFname(globals.get_userID());
  }

  void getLname() async {
    await crudObj.getLname(globals.get_userID());
  }

  void getAddress() async {
    await crudObj.getAddress(globals.get_userID());
  }
  void getEmail() async {
    await crudObj.getEmail(globals.get_userID());
  }



  Future<void> validateAndSubmit() async{
    if(validateAndSave()){
      try {
        if(_formType == FormType.login) {
          String userId = await widget.auth.signInWithEmailAndPassword(_email, _password);

          if(userId == null){
            _showDialogAlertGivenMessage('Please verify your email');
          } else {
            print('Signed in: $userId');
            globals.set_userID(userId);
            await getFname();
            await getLname();
            await getAddress();
            await getEmail();

            //widget.onSignedIn();
            Navigator.of(context).pushReplacementNamed('/homepage');
          }

        } else if (_formType == FormType.register) {
            //The following code will be used when we want to validate only users that have .edu on their email
            if(_email.substring(_email.length - 4, _email.length) != '.edu'){
              globals.registeredSuccessfully = false;
              _showDialogAlertGivenMessage('The email needs to end with ".edu"');
            } else {

              String userId = await widget.auth.createUserWithEmailAndPassword(_email, _password);
              globals.registeredSuccessfully = true;
              globals.set_userID(userId);
              print('Registered user: $userId');
              _showDialogAlertGivenMessage('Registration completed. Please verify your email address');
            }
        } else if(_formType == FormType.forget){
          String result = await widget.auth.sendPasswordResetEmail(this._email);
          _showDialogAlertGivenMessage("If email exists, we will send an email with a link to reset your password.");
        }
      }
      catch(e){
        print('Error $e');
        if (_formType == FormType.register) globals.registeredSuccessfully = false;
        _showDialogAlertGivenCode(e.code);
      }
    }
  }

  void moveToRegister(){
    formKey.currentState.reset();
    setState((){
      _formType = FormType.register;
    });
  }

  void moveToLogin(){
    formKey.currentState.reset();
    setState((){
      _formType = FormType.login;
    });
  }

  void moveToForget(){
    formKey.currentState.reset();
    setState((){
      _formType = FormType.forget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome', textScaleFactor: 2,),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new ListView(
            children: buildInputs() + buildSubmitButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs(){
    if(_formType == FormType.login) {
      child: new LogoPic();
      return [
        new LogoPic(),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Email'),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Password'),
          obscureText: true,
          validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value,
        ),
      ];
    } else if (_formType == FormType.register){
      final _myPassController = TextEditingController();
      //this._mode = globals.currentItemSelected;
      return [
        new TextFormField(
          decoration: new InputDecoration(labelText: 'First Name'),
          validator: (value) => value.isEmpty ? 'First name can\'t be empty' : null,
          onSaved: (value) => _fname = value,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Last Name'),
          validator: (value) => value.isEmpty ? 'Last name can\'t be empty' : null,
          onSaved: (value) => _lname = value,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Email'),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Address'),
          validator: (value) => value.isEmpty ? 'Address can\'t be empty' : null,
          onSaved: (value) => _address = value,
        ),
        new Text('\nFormat: Street Address City State Abbreviation ZipCode'),
        new Text('Example: 1320 S Dixie Hwy Coral Gables FL 33146'),
        new TextFormField(
          controller: _myPassController,
          decoration: new InputDecoration(labelText: 'Password'),
          obscureText: true,
          validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Retype Password'),
          obscureText: true,
          validator: (value) => value != _myPassController.text ? 'Retype password' : null,
          onSaved: (value) => _password = value,
        ),
        /*new DropdownButton<String>(
          value: globals.currentItemSelected,
          items: globals.UserModes.map((String dropDownStringItem) {
            return new DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: new Text(dropDownStringItem),
            );
          }).toList(),
          onChanged: (String newValueSelected) {
            _onDropDownItemSelected(newValueSelected);
          },
          //hint: new Text("Select mode"),

        ) , */
        new Text("\nAdd Profile Picture:"),
         Column(
             children: <Widget> [
               Padding(
                 padding: EdgeInsets.all(10.0),
               ),
    Container(
      width: 100,
    height: 100,
    child: ClipOval(
                 child: image == null ?new Text(""):Image.file(image),
               )),
               new RaisedButton(
                   onPressed: picker,
                   child: new Icon(Icons.camera_alt)),
             ]),
      ];
    } else if (_formType == FormType.forget){
      return [
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Email'),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value,
        ),
      ];
    }
  }

  List <Widget> buildSubmitButtons() {
    if(_formType == FormType.login) {

      return [
        new RaisedButton(
          child: new Text('Log in', style: new TextStyle(fontSize: 20.0, color: Colors.white), ),
          color: Colors.blueGrey,
          onPressed: validateAndSubmit,
        ),
        new FlatButton (
          child: new Text('Forgot Password?', style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToForget,
        ),
        new FlatButton (
        child: new
          Text('Create an account', style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToRegister,
        ),
      ];
    } else if (_formType == FormType.register){
      return [
        new RaisedButton(
          child: new Text('Create an Account', style: new TextStyle(fontSize: 20.0)),
          onPressed: () {
            validateAndSubmit().then((_){
              print("HERE");
              if(image != null)
                {final StorageReference firebaseStorageRef =
                FirebaseStorage.instance.ref().child(globals.get_userID());
              final StorageUploadTask task = firebaseStorageRef.putFile(image);}
             // else{
              //final StorageReference firebaseStorageRef =
              //FirebaseStorage.instance.ref().child(globals.get_userID());
              //final StorageUploadTask task = firebaseStorageRef.putFile(logopic);}
              addToDatabase();
              print("tried to save in database");
              moveToLogin();
            });
          },
        ),
        new FlatButton (
        child: new Text('Have an account? Login', style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToLogin,
        ),

      ];
    } else if (_formType == FormType.forget){
      return [
        new RaisedButton(
        child: new Text('Send Email', style: new TextStyle(fontSize: 20.0)),
        onPressed: validateAndSubmit,
       ),
        new FlatButton (
          child: new Text('Go Back to Login', style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToLogin,
        ),
      ];
    }
  }

  void _showDialogAlertGivenMessage(String message){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Text(message),
          );
        }
    );
  }

  void _showDialogAlertGivenCode(String code) {
    if(_formType == FormType.login){
      for(int i = 0; i < globals.Login_Errors.length; i++){
        if(code == globals.Login_Errors[i]){
          _showDialogAlertGivenMessage(globals.Login_Messages[i]);
        }
      }
    } else if (_formType == FormType.register){
      for(int i = 0; i < globals.Register_Errors.length; i++){
        if(code == globals.Register_Errors[i]){
          _showDialogAlertGivenMessage(globals.Register_Messages[i]);
        }
      }
    } else if (_formType == FormType.forget){
      for(int i = 0; i < globals.Forget_Errors.length; i++){
        if(code == globals.Forget_Errors[i]){
          print(globals.Forget_Errors[i] + '\n');
          _showDialogAlertGivenMessage(globals.Forget_Messages[i]);
        }
      }
    }
  }

  /*void _onDropDownItemSelected(String newValueSelected){
    setState(() {
      globals.currentItemSelected = newValueSelected;
      this._mode = newValueSelected;
    });
  }*/

  void _onRegistration(bool registration){
    setState(() {
      globals.registeredSuccessfully = registration;
    });
  }

  void addToDatabase() async {
    if(globals.registeredSuccessfully == true) {
      Map <String, dynamic> userData = {
        'email': this._email,
        'fname': this._fname,
        'lname': this._lname,
        'uid' : globals.get_userID(),
        'address': this._address,
      };
      crudObj.addData(userData).catchError((e) {
        print(e);
      });
      moveToLogin();
    }
  }
}
class LogoPic extends StatelessWidget
{
  @override
  Widget build(BuildContext context){
  var assetsImage = new AssetImage('images/UdriveLogo.png');
  var imageLogo = new Image(image: assetsImage,width: 250.0,height: 250.0,);
  return new Container(child: imageLogo);
}
}