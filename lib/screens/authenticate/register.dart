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
  String email='';
  String password = '';
  String error = '';
 
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: Text('Register'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            color: Colors.white,
            label: Text('Sign In'),
            onPressed: (){
              widget.toggleView();
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 90, 30, 0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                  validator: (val) => val.isEmpty ? 'Enter an email!':null,
                  onChanged: (val){
                    setState(() => email = val);
                  },
                ),

                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password'
                  ),
                  validator: (val) => val.length <6 ? 'Enter 6 digit password':null,
                  obscureText: true,
                  onChanged: (val){
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 20),
                RaisedButton(
                  color: Color(0xFF2196F3),
                  child: Text(
                    'Sign Up',
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      setState(() {
                        loading = true;
                      });
                      @override
                      dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                      if (result == null){
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
                  style: TextStyle(color: Colors.red,fontSize: 16)
                  )
              ],
            ),
          ),
        )
      )
    );
  }
}