import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'globals.dart' as globals;
import 'services/crud.dart';


class LoginPage extends StatefulWidget {

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
  String _mode;
  String _uid;
  FormType _formType = FormType.login;

  crudMethods crudObj = new crudMethods();

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async{
    if(validateAndSave()){
      try {
        if(_formType == FormType.login) {
          FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
          if(user.isEmailVerified || user == null){
            print('Signed in: ${user.uid}');
          }
          else if (!user.isEmailVerified) {
            FirebaseAuth.instance.signOut();
            _showDialogAlertGivenMessage('Please verify your email');
          }
        } else if (_formType == FormType.register) {
            //The following code will be used when we want to validate only users that have .edu on their email
            if(_email.substring(_email.length - 4, _email.length) != '.edu'){
              _showDialogAlertGivenMessage('The email needs to end with ".edu"');
            } else {
              FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
              globals.registeredSuccessfully = true;
              user.sendEmailVerification();
              print('Registered user: ${user.uid}');
              _uid = '${user.uid}';
            }
        } else if(_formType == FormType.forget){
          FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        }
      }
      catch(e){
        print('Error $e');
        globals.registeredSuccessfully = false;
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
        title: Text('Flutter login demo'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new ListView(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInputs() + buildSubmitButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs(){
    if(_formType == FormType.login) {
      return [
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
        new DropdownButton<String>(
          value: globals.currentItemSelected,
          items: globals.UserModes.map((String dropDownStringItem) {
            return new DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: new Text(dropDownStringItem),
            );
          }).toList(),
          onChanged: (String newValueSelected) {
            _onDropDownItemSelected(newValueSelected);
            _mode = newValueSelected;
          },
          //hint: new Text("Select mode"),

        ),
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

  List <Widget> buildSubmitButtons(){
    if(_formType == FormType.login) {
      return [
        new RaisedButton(
          child: new Text('Login', style: new TextStyle(fontSize: 20.0)),
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
              validateAndSubmit();
             // Navigator.of(context).pop();
              if(globals.registeredSuccessfully) {
                Map<String,dynamic> userData = {
                  'email': this._email,
                  'fname': this._fname,
                  'lname': this._lname,
                  'mode': _mode,
                  'uid' : _uid
                };
                crudObj.addData(userData).catchError((e) {
                  print(e);
                });
                moveToLogin();
              }
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
        onPressed: () {
          validateAndSubmit();
          _showDialogAlertGivenMessage('If email exists, we will send an email with a link to reset your password');
        }

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
    }
  }

  void _onDropDownItemSelected(String newValueSelected){
    setState(() {
      globals.currentItemSelected = newValueSelected;
    });
  }
}