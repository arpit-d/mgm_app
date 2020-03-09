import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  home: DischargeSum(),
));
class DischargeSum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vaccination Reminder'),
        backgroundColor: Color(0xFF7f5fec),
      ),
      body:DischargeSumBodyPage(),
    );
  }
}
class DischargeSumBodyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}