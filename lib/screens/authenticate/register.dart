import 'package:flutter/material.dart';
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
  var converted;

  String convertDate(DateTime _dateTime){
    var dateTime = DateTime.parse(_dateTime.toString());
    var formattedDate = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
    return formattedDate;
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
                      child: Text('Pick a Date'),
                      onPressed: (){
                        showDatePicker(context: context, initialDate: _dateTime == null?DateTime.now():_dateTime,
                         firstDate: DateTime(2000), 
                         lastDate: DateTime.now()
                         ).then((date){
                           setState((){
                             _dateTime = date;
                              converted = convertDate(_dateTime);
                           });
                         });
                        
                      },
                    
                    ),
                      RaisedButton(
                        color: Color(0xFF2196F3),
                        child: Text(
                          'Sign Up',
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            @override
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    email, password, userName, converted);
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
            )
          )
         );
  }
}
