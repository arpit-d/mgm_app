import 'package:flutter/material.dart';
import 'package:mgm_app/services/auth.dart';
import 'package:mgm_app/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

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
        backgroundColor: Color(0xFF0097A7),
        title: Text('Sign In'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Register'),
            onPressed: (){
              widget.toggleView();
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                TextFormField(
                  validator: (val) => val.isEmpty ? 'Incorrect email!':null,
                  onChanged: (val){
                    setState(() => email = val);
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (val) => val.isEmpty ? 'Invalid password':null,
                  obscureText: true,
                  onChanged: (val){
                    
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 20),
                RaisedButton(
                  color: Color(0xFF2196F3),
                  child: Text(
                    'Sign In',
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      setState(() => loading = true);
                     dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if (result == null){
                       setState(() {
                         
                         loading = false;
                         error = 'Invalid Credentials!';
                       
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