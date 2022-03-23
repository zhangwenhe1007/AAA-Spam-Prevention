import 'package:flutter/material.dart';
import 'pages/call_numbers.dart';
import 'pages/sms_messages.dart';
import 'pages/microphone_icon.dart';
//import 'package:tflite_flutter/tflite_flutter.dart';

//TO BE FIXED: KEEP THE INCOMING NUMBERS AND MESSAGES SHOWN IN THE APP

//here, I'll define our primary color

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: const Color(0xFFD93739),
        ),
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
        //This changes the font of the labels in the bottom navigation bar, i put it to 0
        selectedFontSize: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: ' ',
            //label: 'Phone Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sms),
            label: " ",
            //label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: ' ',

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
