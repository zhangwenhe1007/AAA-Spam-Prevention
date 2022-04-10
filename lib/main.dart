import 'package:flutter/material.dart';
import 'pages/call_numbers.dart';
import 'pages/sms_messages.dart';
import 'pages/microphone_icon.dart';
//import 'package:tflite_flutter/tflite_flutter.dart';

//here, I'll define our primary color

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AiBert",
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: const Color(0xFFD93739),
        ),
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'AiBert'),
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
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Phone Calls',
            //label: 'Phone Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sms),
            label: "Messages",
            //label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Vocal Analysis',

            //label: 'Vocal Analysis',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}