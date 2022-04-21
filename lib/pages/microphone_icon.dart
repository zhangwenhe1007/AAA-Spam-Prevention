import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class MicrophonePage extends StatefulWidget {
  @override
  _MicrophonePageState createState() => _MicrophonePageState();
}

class _MicrophonePageState extends State<MicrophonePage> {
  static const platform = const MethodChannel("com.flutter.speech/speech");


  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: SingleChildScrollView(
            child: Text('Oops! You have encountered an error. This function is currently unavailable.'),
            )
        );
      }
    );
  } 

  Future Printy() async {
    String value;
    final arguments = {'name': 'Wenhe'};

    try {
      value = await platform.invokeMethod('Printy', arguments);
    } catch (e) {
      print('This is the message');
      print(e);
    }

    print(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('AiBert', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w100, // light
    fontFamily: 'Blue Vinyl',)),
      ),
      body: Center(
        child: Container(
          width: 150.0,
          height: 150.0,
          child: FloatingActionButton(
          onPressed: () {
            Printy();
          },
          child: Icon(Icons.mic, size: 50.0),
        ),
        ),
      ),
    );
  }
}