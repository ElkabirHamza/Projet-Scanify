import 'package:flutter/material.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';
 
void main() {
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
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tesseract OCR Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                String imagePath = 'path_to_your_image.png'; // Remplacez ceci par le chemin de votre image.
 
                try {
                  String result = await TesseractOcr.extractText(imagePath);
                  setState(() {
                    recognizedText = result;
                  });
                } catch (e) {
                  print('Error: $e');
                }
              },
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