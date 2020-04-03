import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mgm_app/models/user.dart';
import 'package:mgm_app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  home: MedHist(),
));
class MedHist extends StatefulWidget {
  @override
  _MedHistState createState() => _MedHistState();
}

class _MedHistState extends State<MedHist> {
  final AuthService _auth = AuthService();
  File _image;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    Future getImageFromCamera() async {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        _image = image;
        print('Image $_image');
      });
      
      String fileName = basename(_image.path);
      StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = reference.putFile(_image);
      StorageTaskSnapshot snapshot = await uploadTask.onComplete;
      setState(() {
        print('success');
      });
    }
    
    Future getImageFromGallery() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        print('Image $_image');
      });
      String fileName = basename(_image.path);
      StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = reference.putFile(_image);
      StorageTaskSnapshot snapshot = await uploadTask.onComplete;
      setState(() {
        print('success');
      });
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical History'),
        backgroundColor: Color(0xFF05b39e),
      ),
      bottomNavigationBar: BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(icon: Icon(Icons.camera_alt), onPressed: () {
            getImageFromCamera();
          }, color: Colors.teal,tooltip: 'Camera',),
          IconButton(icon: Icon(Icons.photo_album), onPressed: () {
            getImageFromGallery();
           
          },color: Colors.teal,tooltip: 'Gallery',),
        ],
      ),
      ),
      body: ImageF(),
    );
  }
}

class ImageF extends StatefulWidget {
  @override
  _ImageFState createState() => _ImageFState();
}

class _ImageFState extends State<ImageF> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Container(
        
      ),
    );
  }
}

