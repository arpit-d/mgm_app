//import 'package:mgm_app/models/VaccList.dart';
import 'package:flutter/material.dart';
import 'package:mgm_app/models/vaccList.dart';

class VaccTile extends StatelessWidget {

  final VaccList vac;
  VaccTile({ this.vac });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Text(vac.vaccName),
          
        ),
      ),
    );
  }
}