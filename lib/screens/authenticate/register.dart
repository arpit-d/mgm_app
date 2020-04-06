import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mgm_app/services/auth.dart';
import 'package:mgm_app/shared/loading.dart';
 	

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  //text field state
  String email = '';
  String password = '';
  String error = '';
  String userName = '';
  DateTime _dateTime;
  var dateTime;
  String deviceToken = '';
  

  String convertDate(DateTime _dateTime) {
    
    var dateTime = DateFormat('dd-MM-yyyy');
    var formattedDate = dateTime.format(_dateTime);
    print(formattedDate);
    return formattedDate;
  }

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _getToken(){
    _firebaseMessaging.getToken().then((deviceT) {
      setState(() {
        deviceToken = deviceT;
      });
    });
  } 
  @override
  void initState() {
    super.initState();
    _getToken();
  }
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue.shade400,
              title: Text('Register'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Sign In'),
                  onPressed: () {
                    widget.toggleView();
                  },
                )
              ],
            ),
            body: Center(
                child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(30, 90, 30, 0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email!' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Password'),
                        validator: (val) =>
                            val.length < 6 ? 'Enter 6 digit password' : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 20),
                      
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Username'),
                        validator: (val) =>
                            val.isEmpty ? 'Enter username' : null,
                        onChanged: (val) {
                          setState(() => userName = val);
                        },
                      ),
                      SizedBox(height: 20),
                      RaisedButton(
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
                        child: Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color.fromARGB(255, 148, 231, 225),
                                  Color.fromARGB(255, 62, 182, 226)
                                ],
                              ),
                                //borderRadius: BorderRadius.all(Radius.circular(80.0))
                              ),
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: const Text('Select Birthday',
                              style: TextStyle(fontSize: 20)),
                        ),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: _dateTime == null
                                      ? DateTime.now()
                                      : _dateTime,
                                  firstDate: DateTime(1920),
                                  lastDate: DateTime.now())
                              .then((date) {
                            setState(() {
                              _dateTime = date;
                              dateTime = convertDate(_dateTime);
                            });
                          });
                        },
                      ),
                      RaisedButton(
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
                        child: Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color.fromARGB(255, 148, 231, 225),
                                  Color.fromARGB(255, 62, 182, 226)
                                ],
                              ),
                                //borderRadius: BorderRadius.all(Radius.circular(80.0))
                              ),
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: const Text('Sign Up',
                              style: TextStyle(fontSize: 20)),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            @override
                            
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    email, password, userName, dateTime, deviceToken);
                                    
                            if (result == null) {
                              setState(() {
                                error = 'Invalid Email';
                                loading = false;
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(error,
                          style: TextStyle(color: Colors.red, fontSize: 16))
                    ],
                  ),
                ),
              ),
            )));
  }
}
