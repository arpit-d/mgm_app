import 'package:flutter/material.dart';
import 'package:mgm_app/services/auth.dart';

void main() => runApp(MaterialApp(
  home: DrHome(),
));
class DrHome extends StatelessWidget {
   final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Dashboard'),
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
              FlatButton.icon(onPressed: ()async{
                await _auth.signOut();
              }, 
              icon: Icon(Icons.person), 
              color: Colors.white,
              label: Text('logout'))
        ]
      ),
      body: DrHomePage(),
    );
  }

}
class DrHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}