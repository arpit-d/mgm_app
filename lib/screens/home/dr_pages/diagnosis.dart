import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    home: DiagHome(),
  )
);

class DiagHome extends StatefulWidget {
  @override
  _DiagHomeState createState() => _DiagHomeState();
}

class _DiagHomeState extends State<DiagHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnosis Report'),
      ),
      body: DiagBody(),
    );
  }
}

class Patient {
  String userName;
  String type;
  Patient({this.userName,this.type});
}

class DiagBody extends StatefulWidget {
  @override
  _DiagBodyState createState() => _DiagBodyState();
}

class _DiagBodyState extends State<DiagBody> {
  final Patient patient = Patient();
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}