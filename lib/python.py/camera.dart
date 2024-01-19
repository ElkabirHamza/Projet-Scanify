[21:13] El Kabir Hamza
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
 
void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  final firstCamera = cameras.first;
 
  runApp(MyApp(firstCamera: firstCamera));

}
 
class MyApp extends StatelessWidget {

  final CameraDescription firstCamera;
 
  const MyApp({Key? key, required this.firstCamera}) : super(key: key);
 
  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      home: MyHomePage(camera: firstCamera),

    );

  }

}
 
class MyHomePage extends StatefulWidget {

  final CameraDescription camera;
 
  const MyHomePage({Key? key, required this.camera}) : super(key: key);
 
  @override

  _MyHomePageState createState() => _MyHomePageState();

}
 
class _MyHomePageState extends State<MyHomePage> {

  late CameraController _controller;

  late Future<void> _initializeControllerFuture;
 
  @override

  void initState() {

    super.initState();

    _controller = CameraController(

      widget.camera,

      ResolutionPreset.medium,

    );

    _initializeControllerFuture = _controller.initialize();

  }
 
  @override

  void dispose() {

    _controller.dispose();

    super.dispose();

  }
 
  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text('Camera Example'),

      ),

      body: FutureBuilder<void>(

        future: _initializeControllerFuture,

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.done) {

            return CameraPreview(_controller);

          } else {

            return Center(child: CircularProgressIndicator());

          }

        },

      ),

      floatingActionButton: FloatingActionButton(

        onPressed: () async {

          try {

            await _initializeControllerFuture;
 
            final image = await _controller.takePicture();

            // Utilisez l'image capturée comme bon vous semble (par exemple, pour l'OCR).

          } catch (e) {

            print('Error: $e');

          }

        },

        child: Icon(Icons.camera),

      ),

    );

  }

}

[21:14] El Kabir Hamza
import 'dart:io';
 
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import 'package:image_picker/image_picker.dart';
 
void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());

}
 
class MyApp extends StatelessWidget {

  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      home: MyHomePage(),

    );

  }

}
 
class MyHomePage extends StatefulWidget {

  @override

  _MyHomePageState createState() => _MyHomePageState();

}
 
class _MyHomePageState extends State<MyHomePage> {

  File? _pickedImage;

  String _recognizedText = 'No text recognized';
 
  Future<void> _pickImage() async {

    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
 
    if (pickedFile != null) {

      setState(() {

        _pickedImage = File(pickedFile.path);

        _recognizedText = 'No text recognized';

      });

    }

  }
 
  Future<void> _performOCR() async {

    if (_pickedImage == null) {

      return;

    }
 
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(_pickedImage!);

    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
 
    try {

      VisionText visionText = await textRecognizer.processImage(visionImage);

      String result = visionText.text;

      setState(() {

        _recognizedText = result;

      });

    } catch (e) {

      print('Error: $e');

    } finally {

      textRecognizer.close();

    }

  }
 
  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text('Scan and OCR Example'),

      ),

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[

            _pickedImage != null

                ? Image.file(

                    _pickedImage!,

                    height: 200,

                  )

                : Container(),

            SizedBox(height: 20),

            ElevatedButton(

              onPressed: _pickImage,

              child: Text('Pick Image'),

            ),

            SizedBox(height: 10),

            ElevatedButton(

              onPressed: _performOCR,

              child: Text('Perform OCR'),

            ),

            SizedBox(height: 20),

            Text('Recognized Text:'),

            SizedBox(height: 10),

            Text(_recognizedText),

          ],

        ),

      ),

    );

  }

}
