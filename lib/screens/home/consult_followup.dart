import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  home: ConsultFollowUp(),
));
class ConsultFollowUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultation Follow Up Reminder'),
        backgroundColor: Color(0xFF05b39e),
      ),
      body: ConsultFollowUpBodyPage(),
    );
  }
}
class ConsultFollowUpBodyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
