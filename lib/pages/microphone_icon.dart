import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';

class MicrophonePage extends StatefulWidget {
  @override
  _MicrophonePageState createState() => _MicrophonePageState();
}

class _MicrophonePageState extends State<MicrophonePage> {
  static const platform = const MethodChannel("com.flutter.speech/speech");
  String message = 'Press the button to start vocal protection';
  double digit = 20.0;
  Color color = Colors.white;

  Future<void> _showMyDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                'ALERT',
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: Text(
                  'The call is potentially dangerous. Please proceed with caution',
                  textAlign: TextAlign.center,
                ),
              ));
        });
  }

  // Future Printy() async {
  //   String value;
  //   final arguments = {'name': 'Wenhe'};

  //   try {
  //     value = await platform.invokeMethod('Printy', arguments);
  //   } catch (e) {
  //     print('This is the message');
  //     print(e);
  //   }

  //   print(value);
  // }

  void change() {
    //sleep(Duration(seconds: 10));
    message = "This is CIBC calling you from Montreal";
    digit = 15.0;
    color = Colors.red[100];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('AiBert',
            style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w100, // light
              fontFamily: 'Blue Vinyl',
            )),
      ),
      body: Container(
        decoration: BoxDecoration(color: color),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 100.0),
                width: 300.0,
                height: 300.0,
                child: Center(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: digit, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Container(
                  width: 150.0,
                  height: 300.0,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 200.0,
                        height: 200.0,
                        child: FloatingActionButton.large(
                          onPressed: () async {
                            
                            setState(() {
                              message = "Listening...";
                            });
                            await Future.delayed(Duration(seconds: 5));
                            setState(() {
                               change();

                              _showMyDialog();
                              SystemChrome.setSystemUIOverlayStyle(
                                  SystemUiOverlayStyle(
                                statusBarColor: Colors.red, // status bar color
                              ));
                            });
                          },
                          child: Icon(Icons.mic, size: 50.0),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              message =
                                  'Press the button to start vocal protection';
                              digit = 20.0;
                              //color = Colors.green[100];
                              color = Colors.white;
                            });
                          },
                          child: Text("Clear"))
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
