import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../networking.dart';
import '../database.dart';
import '../models/numbers.dart';

import 'dart:async';

class PageOne extends StatefulWidget {
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  //This will be the list of entries in the database
  List<Numbers> num = [];

  FlutterLocalNotificationsPlugin localNotification2 =
      FlutterLocalNotificationsPlugin();
  static const _channel1 =
      BasicMessageChannel('com.appNumber/demo', StringCodec());

  @override
  void initState() {
    super.initState();

    //Initialize the database
    _getData();

    //Initialize the notification package
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

        //Get the api link
        var api = GetPostApi(link: '/phonenumber?number=$message');

        //This method sends an http request to server. The post object the a json response.
        api.fetchPost().then((post) {
          if (post.ratingNum.toInt() == 2) {
            showNotification(
                'Alert', 'You have received a spam call from ' + message);
          }

          print(post.ratingNum.toInt());
          setState(() {
            var newDBUser = Numbers(
              number: message,
              result: post.messageNum.toString(),
              rating: post.ratingNum.toInt(),
            );
            DBProvider.db.insertData(newDBUser, 'numbers');
            print('New message arrived, the message is $newDBUser');
            _getData();
          });
        }, onError: (error) {
          setState(() {
            var newDBUser = Numbers(
              number: error.toString(),
              result: "",
              rating: 0,
            );
            DBProvider.db.insertData(newDBUser, 'numbers');
            print('New message arrived, but there is an error $newDBUser');
            _getData();
          });
        });
        return 'OK';
      },
    );
  }

  //This is the stream which continuously sends data to StreamBuilder
  Stream<dynamic> _getData() async* {
    print('LaunchState databaseInitialization begin');
    await DBProvider.db.initDB();
    print('LaunchState databaseInitialization end');
    final _userData = await DBProvider.db.getNumbers('numbers');
    if (_userData != null) {
      print('Got user data, which is >>');
      print(_userData);
    } else {
      print('No data');
    }
    yield _userData;
  }

  //This is the notification function. It takes a parameters: the title and the message
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

  //When the user clicks on the notification, the app opens
  //TODO: add navigation routes to the app, so that the app opens at the calls history page if a new scam call is detected
  //and opens at sms page is scam sms is detected
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
      body: StreamBuilder<dynamic>(
        stream: _getData(),
        builder: (context, userData) {
          switch (userData.connectionState) {
            case ConnectionState.none:
              return Container();
            case ConnectionState.waiting:
              return Container();
            case ConnectionState.active:
              return Container();
            case ConnectionState.done:
              if (userData.data != null) {
                num = List<Numbers>.from(userData.data);
                print(num);
                return Container(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: num.length,
                      itemBuilder: (context, i) {
                        return _buildTile(num[num.length - (i + 1)]);
                      }),
                );
              } else {
                return Container(
                  child: Center(
                    child: Opacity(
                        opacity: 0.5,
                        child:
                            Text('Empty inbox', textAlign: TextAlign.center)),
                  ),
                );
              }
          }
          return Container();
        },
      ),
    );
  }

  //ALIGN EMPTY INBOX TEXT AT CENTER, INCREASE SIZE
  //If rating is 1, it is ham. If it is 2, it is spam.
  Widget _buildIcon(int rating) {
    if (rating == 1) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Icon(Icons.check)]);
    } else if (rating == 2) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Icon(Icons.warning)]);
    } else {
      return null;
    }
  }

  //Each message is a tile
  Widget _buildTile(Numbers num) {
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          shape: Border(
            right: BorderSide(
                color: num.rating == 2
                    ? Colors.redAccent[100]
                    : Colors.lightGreenAccent[100],
                width: 5),
          ),
          child: ListTile(
              title: Text(
                num.number,
                style: TextStyle(fontSize: 20.0),
              ),
              subtitle: Text(num.result, style: TextStyle(fontSize: 15.0)),
              trailing: _buildIcon(num.rating),
              onTap: () {
                _showMyDialog(num);
              }),
        ));
  }

  //When the user clicks on a tile, a dialog box opens.
  //TODO: make it so that tapping the Yes or No button updates the information of the message in the database.
  //TODO: make a drop-down menu for user to select which type of spam
  Future<void> _showMyDialog(Numbers num) async {
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
                    //Update the num entry that is related to each ListTile
                    num.rating = 2;
                    DBProvider.db.updateData(num, 'numbers');
                    _getData();
                    String add_number = num.number;
                    GetPostApi(link: '/addphonenumber?number=$add_number')
                        .fetchPost();
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
                    num.rating = 1;
                    DBProvider.db.updateData(num, 'numbers');
                    _getData();
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
