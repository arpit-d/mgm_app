import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  home: PatientHist(),
));
class PatientHist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Medical History'),
        backgroundColor: Color(0xFF05b39e),
      ),
      body: PatientHistBodyPage(),
    );
  }
}
class PatientHistBodyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}