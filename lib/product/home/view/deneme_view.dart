import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DenemeView extends StatefulWidget {
  const DenemeView({Key? key}) : super(key: key);
  @override
// ignore: library_private_types_in_public_api
  _DenemeViewState createState() => _DenemeViewState();
}

class _DenemeViewState extends State<DenemeView> {
  final platform = const MethodChannel("text_to_speech");

  Future<void> speak(String text) async {
    try {
      print("girdi 3");
      await platform.invokeMethod("speakText", {"text": text});
      print("girdi");
    } on PlatformException catch (e) {
      print("girdi 2");
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text to speech without plugin"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              speak("Hello, I'm Talkios. Which flowers do you like?");
            },
            child: const Text("Speak")),
      ),
    );
  }
}
