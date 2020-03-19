import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  home: MedHist(),
));
class MedHist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical History'),
        backgroundColor: Color(0xFF05b39e),
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

  File _imageFile;



  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = selected;
    });
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      
    );
    setState(() {
      _imageFile = cropped??_imageFile;
    });
  }
  void _clear() {
    setState(()=> _imageFile = null);
  }
  

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
            Expanded(
                          child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                
        children: <Widget>[
          if (_imageFile != null) ...[

              Image.file(_imageFile),

              Row(
                children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.crop),
                    onPressed: _cropImage,
                  ),
                  FlatButton(
                    child: Icon(Icons.refresh),
                    onPressed: _clear,
                  ),
                ],
              ),

              Uploader(file: _imageFile)
                  ]
                ],
              ),
            ),
          ],
        ),
      )
      
    );
  }
}

class Uploader extends StatefulWidget {
  final File file;
  Uploader({Key key,this.file}):super(key:key);
  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  @override
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://mgm-app-e3ba6.appspot.com');

  StorageUploadTask _uploadTask;

  /// Starts an upload task
  void _startUpload() {

    /// Unique file name for the file
    String filePath = 'images/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {

      /// Manage the task state and event subscription with a StreamBuilder
      

          
    } else {

      // Allows user to decide when to start the upload
      return FlatButton.icon(
          label: Text('Upload to Firebase'),
          icon: Icon(Icons.cloud_upload),
          onPressed: _startUpload,
        );

    }
  }
}
