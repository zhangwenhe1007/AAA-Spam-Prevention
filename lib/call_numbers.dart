import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

import './networking.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

// Path to file: '/data/user/0/com.example.alerte_anti_arnaqueurs/files/<file name>'

class PageOne extends StatefulWidget {
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  List<String> numbers;
  List<String> numbersDescription;
  List<String> numbersModify;

  FlutterLocalNotificationsPlugin localNotification2 =
      FlutterLocalNotificationsPlugin();
  static const _channel1 =
      BasicMessageChannel('com.appNumber/demo', StringCodec());
  String link = "";
  String _phoneNumber = "";
  String _numberResult = "";
  String rating = "";
  int iconState = 0;
  int pageState = 0;

  @override
  void initState() {
    super.initState(); //search on this method
    readData('/data/user/0/com.example.alerte_anti_arnaqueurs/files/numbers.csv').then((List value) {
      setState(() {
        value.remove('');
        numbers = value;
      });
    });

    readData('/data/user/0/com.example.alerte_anti_arnaqueurs/files/numbers_message.csv').then((List value) {
      setState(() {
        value.remove('');
        numbersDescription = value;
      });
    });

    readData('/data/user/0/com.example.alerte_anti_arnaqueurs/files/numbers_modify.csv').then((List value) {
      setState(() {
        value.remove('');
        numbersModify = value;
        pageState++;
      });
    });

    var androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_notification');
    var iOSInitialize = IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    localNotification2.initialize(initializationSettings,
        onSelectNotification: onSelectNotif2);
    _channel1.setMessageHandler(
      (String message) async {
        message = message.replaceAll(new RegExp(r'[^\w\s]+'), '');
        message = message.substring(1);
        print("Received phone number = $message");
        setState(() {
          _phoneNumber = message;
          pageState++;
        });
            readData('/data/user/0/com.example.alerte_anti_arnaqueurs/files/numbers.csv').then((List value) {
      setState(() {
        value.remove('');
        numbers = value;
      });
    });

    readData('/data/user/0/com.example.alerte_anti_arnaqueurs/files/numbers_message.csv').then((List value) {
      setState(() {
        value.remove('');
        numbersDescription = value;
      });
    });

    readData('/data/user/0/com.example.alerte_anti_arnaqueurs/files/numbers_modify.csv').then((List value) {
      setState(() {
        value.remove('');
        numbersModify = value;
      });
    });
        link = 'phonenumber?number=$_phoneNumber';
        var api = GetPostApi(link: link);
        api.fetchPost().then((post) {
          setState(() {
            _numberResult = post.title.toString();
            rating = post.rating.toString();
          });
        }, onError: (error) {
          setState(() {
            _numberResult = error.toString();
          });
        });
        print('This number is ' + rating);
        if (rating == 'spam') {
          showNotification(
              'Alert', 'You have received a spam call from ' + _phoneNumber);
          setState(() {
            iconState = 2;
          });
        } else if (rating == 'ham') {
          setState(() {
            iconState = 1;
          });
        } else if (rating == "") {
          setState(() {
            iconState = 0;
          });
        }
        return 'OK';
      },
    );
  }

  Future showNotification(String notifTitle, String notifMessage) async {
    print('received');
    var androidDetails = AndroidNotificationDetails(
      "channelID",
      "Local Notification",
      "This is the description of the Notification, can be changed",
      priority: Priority.high,
      importance: Importance.max,
    );
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotification2.show(
      0,
      '$notifTitle',
      '$notifMessage',
      generalNotificationDetails,
      payload: 'WELCOME TO THE NOTIFICATION CHANNEL',
    );
  }

  Future onSelectNotif2(String payload) async {
    print('Phonenumber part was selected');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('New Alert has been detected'),
            ],
          ),
        ),
      ),
    );
  }

  Future<List> readData(String path) async {
    final file = File(path);
    try {
      // Read the file
      final contents = await file.readAsString();
      List content = contents.split('\n');
      print(content);
      return content;
    } catch (e) {
      print(e.toString());
    }
  }
    //PROBLEM: when writing data, code writes empty strings into the csv files followed by \n
    Future writeData(String path, String string) async {
    final file = File(path);

    // Write the file
    print('This is the string $string');
    file.writeAsString(string);
    file.writeAsString('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Incoming Numbers'),
        ),
        body: pageState != 0
            ? ListView.builder(
              itemCount: numbers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                      title: Text('${numbers[index]}', style: TextStyle(fontSize: 24.0)),
                      trailing: _buildIcon(),
                      subtitle: Text('${numbersDescription[index]}', style: TextStyle(fontSize: 20.0)),
                      onTap: () {
                        if ('${numbersModify[index]}' == 'Y') {
                          _showMyDialog(index);
                        }
          }),
    );
              }
            )
              
             /* ListView(
                children: <Widget>[
          _buildPage(_phoneNumber, _numberResult)
        ],
              ) */

            : Container(
                child: Center(
                  child: Opacity(
                      opacity: 0.5,
                      child: Text('Empty inbox', textAlign: TextAlign.center)),
                ),
              ));
  }

  //ALIGN EMPTY INBOX TEXT AT CENTER, INCREASE SIZE
  Widget _buildIcon() {
    if (iconState == 1) {
      return Icon(Icons.check);
    } else if (iconState == 2) {
      return Icon(Icons.warning);
    }
  }

  /* Widget _buildPage(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
          title: Text(title, style: TextStyle(fontSize: 24.0)),
          trailing: _buildIcon(),
          subtitle: Text(subtitle, style: TextStyle(fontSize: 20.0)),
          onTap: () {
            _showMyDialog();
          }),
    );
  } */

  Future<void> _showMyDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Is this number a spam call?'),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 75.0),
              child: TextButton(
                child: Text('Yes', style: TextStyle(fontSize: 20.0)),
                onPressed: () {
                  setState(() {
                    this.iconState = 2;
                    numbersModify[index] = 'N';
                  });
                  for (String character in numbersModify) {
                    print(character);
                    writeData('/data/user/0/com.example.alerte_anti_arnaqueurs/files/numbers_modify.csv', character);
                  }
                  Navigator.of(context).pop();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: TextButton(
                child: Text('No', style: TextStyle(fontSize: 20.0)),
                onPressed: () {
                  setState(() {
                    this.iconState = 1;
                  });
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }
}

/*Future<List> readMessage() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    try {
      final file = File('$path/config.csv');
      // Read the file
      final input = file.openRead();
      final contents = await input
          .transform(utf8.decoder)
          .transform(CsvToListConverter())
          .toList();
      print(contents);
      //THIS RETURNS A LIST WITHIN A LIST [[DATA]] SO CONTENTS[0] IS THE FIRST LIST IN THE LIST, REPRESENTING THE FIRST ROW WITH ITS VALUES
      return contents;
    } catch (e) {
      return ['Message unavailable', ''];
    }
  } */
  
  /* pickFile() async {
   FilePickerResult result = await FilePicker.platform.pickFiles();
   if (result != null) {
     PlatformFile file = result.files.first;
     final input = new File(file.path).openRead();
     final fields = await input
         .transform(utf8.decoder)
         .transform(new CsvToListConverter())
         .toList();

     print(fields);
   }
 } */

    /*void _loadCSV() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final _rawData = await rootBundle.loadString('$path/config.csv');
    List<List<dynamic>> _listData = CsvToListConverter().convert(_rawData);
    print(_data);
    setState(() {
      _data = _listData;
    });
  } */