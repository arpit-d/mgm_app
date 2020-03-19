import 'package:flutter/material.dart';
void main () => runApp(MaterialApp(
    home: HospLocation(),
));
class HospLocation extends StatefulWidget {
  @override
  _HospLocationState createState() => _HospLocationState();
}

class _HospLocationState extends State<HospLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospital Location'),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }
}