import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  home: PillHome(),
));
class PillHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pill Reminder'),
        backgroundColor: Color(0xFF05b39e),
      ),
      body: PillBodyPage(),
    );
  }
}
class PillBodyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
