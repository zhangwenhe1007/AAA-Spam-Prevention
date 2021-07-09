import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './networking.dart';
import './add_data.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

class PageOne extends StatefulWidget {
  final CounterStorage storage;
  PageOne({Key key, @required this.storage}) : super(key: key);

  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  List dataResult = [];

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
    widget.storage.readMessage().then((value) {
      setState(() {
        dataResult = value;
        print(dataResult);
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
          await widget.storage.writeCounter(_phoneNumber, _numberResult);
          widget.storage.readMessage().then((value) {
            setState(() {
              dataResult = value;
              print(dataResult);
            });
          });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Incoming Numbers'),
        ),
        body: dataResult.length != 0
            ? ListView(
                children: dataResult
                        ?.map<Padding>((list) => _buildPage(list))
                        ?.toList() ??
                    [],
              )
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

  Widget _buildPage(List list) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
          title: Text(list[0].toString(), style: TextStyle(fontSize: 24.0)),
          trailing: _buildIcon(),
          subtitle: Text(list[1].toString(), style: TextStyle(fontSize: 20.0)),
          onTap: () {
            _showMyDialog();
          }),
    );
  }

  Future<void> _showMyDialog() async {
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
                  });
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