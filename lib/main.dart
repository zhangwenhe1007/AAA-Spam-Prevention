import 'package:flutter/material.dart';
import 'pages/call_numbers.dart';
import 'pages/sms_messages.dart';
import 'pages/microphone_icon.dart';
import 'classifier.dart';
//import 'package:tflite_flutter/tflite_flutter.dart';

//TO BE FIXED: KEEP THE INCOMING NUMBERS AND MESSAGES SHOWN IN THE APP

void main() {
  //If I need it to print something, I need to run the the app, and check in the debug console
  print('start');
  Classifier classy = new Classifier();
  //classy._getInfo();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    PageOne(),
    PageTwo(),
    MicrophonePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Phone Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sms),
            label: 'SMS Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Vocal Analysis',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}
