import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
 
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
  String recognizedText = 'No text recognized';
 
  Future<void> performOCR() async {
    String imagePath = 'path_to_your_image.png'; // Remplacez ceci par le chemin de votre image.
 
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFilePath(imagePath);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
 
    try {
      VisionText visionText = await textRecognizer.processImage(visionImage);
      String result = visionText.text;
      setState(() {
        recognizedText = result;
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
        title: Text('OCR Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: performOCR,
              child: Text('Recognize Text'),
            ),
            SizedBox(height: 20),
            Text('Recognized Text:'),
            SizedBox(height: 10),
            Text(recognizedText),
          ],
        ),
      ),
    );
  }
}