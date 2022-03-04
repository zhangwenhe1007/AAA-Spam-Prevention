import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../networking.dart';
import '../models/messages.dart';
import '../database.dart';
import 'dart:convert';

class PageTwo extends StatefulWidget {
  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  bool sentData = false;
  List<Messages> sms = [];
  String _smsMessage = "";
  String _senderNumber = "";

  FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();

  static const _channel2 =
      BasicMessageChannel('com.appSms/demo', StandardMessageCodec());
  // static const _channel3 = BasicMessageChannel('com.appSender/demo', StringCodec());

  @override
  void initState() {
    super.initState();

    //TODO

    var androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_notification');
    var iOSInitialize = IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    localNotification.initialize(initializationSettings,
        onSelectNotification: onSelectNotif);

    _channel2.setMessageHandler((Object messages) async {
      //Convert the Object (type is Internal Linked Map) into a Dart Map object
      Map<int, String> dict = Map<int, String>.from(messages);

      _senderNumber = dict[2].replaceAll(RegExp(r"[^\s\w]"), '');
      _smsMessage = dict[1];

      print("Received SMS = $_smsMessage");

      var api =
          GetPostApi(link: '/message?sms=$_smsMessage&number=$_senderNumber');

      await api.fetchPost().then((post) {
        if (post.ratingNum.toInt() == 2 && sentData == false) {
          showNotification(
              'ALERT',
              _senderNumber +
                  ' has previously been marked spam! <br /> Its may be dangerous!');
          sentData = true;
        } else if (post.ratingSms.toInt() == 2 && sentData == false) {
          showNotification('Alert',
              'SPAM message from ' + _senderNumber +'!');
          sentData = true;
        }

        setState(() {
          var newDBUser = Messages(
            number: _senderNumber,
            result_number: post.messageNum.toString(),
            result_message: post.messageSms.toString(),
            rating_number: post.ratingNum.toInt(),
            rating_sms: post.ratingSms.toInt(),
            message: _smsMessage,
          );
          DBProvider.db.insertData(newDBUser, 'messages');
          print('New message! $newDBUser');
          _getData();
          //This sends the message to our message database with the prediction made by the model.
          //We must turn the prediction into string spam or ham, because the labels in database are strings
          String rating1 = post.ratingSms == 2 ? 'spam' : 'ham';
          GetPostApi(link: '/addmessage?sms=$_smsMessage&rating=$rating1')
                        .fetchPost();
        });
      }, onError: (error) {
        setState(() {
          var newDBUser = Messages(
            number: error.toString(),
            result_number: "",
            result_message: "",
            rating_number: 0,
            rating_sms: 0,
            message: "",
          );
          DBProvider.db.insertData(newDBUser, 'messages');
          print('New message received, but an error occured. $newDBUser');
          _getData();
        });
      });

      /*
      if (send) {
        if (_ratingSms == 'spam') {
          print('sending notif because message is spam');
          showNotification('ALERT',
              'New spam message from ' + _senderNumber + '!');
          setState(() {
            iconState = 2;
            send = false;
          });
        } else if (_ratingSms == 'ham') {
          setState(() {
            iconState = 1;
          });
        }
      } */

      return 'OK';
    });

    /*
    _channel3.setMessageHandler((String message) async {
      send = true;
      message = message.replaceAll(new RegExp(r'[^\w\s]+'), '');
      message = message.substring(1);

      print("Received phone number of sender = $message");
      setState(() {
        _senderNumber = message;
        pageState++;
      });

      link = '/phonenumber?number=$_senderNumber';
      var api = GetPostApi(link: link);
      await api.fetchPost().then((post) {
        setState(() {
          _phoneResult = ' :' + post.title.toString();
          _ratingPhone = post.rating.toString();
        });
      }, onError: (error) {
        setState(() {
          _phoneResult = error.toString();
        });
      });

      print('The rating of phone: ' + _ratingPhone);
      print('The rating of message: ' + _ratingSms);

      if (send) {
        if (_ratingPhone == 'spam') {
          print('sending notif because number is spam');
          showNotification(
              'ALERT',
              _senderNumber +
                  ' has previously been marked spam! The content of the message may be dangerous!');
          setState(() {
            iconState = 2;
            send = false;
          });
        } else if (_ratingPhone == 'ham') {
          setState(() {
            iconState = 1;
          });
        }
      }

      return 'OK';
    });
    */
  }

  Stream<dynamic> _getData() async* {
    print('LaunchState databaseInitialization begin');
    await DBProvider.db.initDB();
    print('LaunchState databaseInitialization end');
    final _userData = await DBProvider.db.getNumbers('messages');
    if (_userData != null) {
      print('Got user data, which is >>');
      print(_userData);
    } else {
      print('No data');
    }
    yield _userData;
  }

  Future showNotification(String notifTitle, String notifMessage) async {
    print('Notification has been deployed');
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
    await localNotification.show(
      0,
      '$notifTitle',
      '$notifMessage',
      generalNotificationDetails,
      payload: 'WELCOME TO THE NOTIFICATION CHANNEL',
    );
  }

  Future onSelectNotif(String payload) async {
    print('Notification was selected');
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
                sms = List<Messages>.from(userData.data);
                print(sms);
                return Container(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: sms.length,
                      itemBuilder: (context, i) {
                        return _buildTile(sms[i]);
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

  Widget _buildIcon(int rating_num, int rating_sms) {
    if (rating_num == 1 && rating_sms == 1) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Icon(Icons.check)]);
    } else if (rating_num == 2 || rating_sms == 2) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Icon(Icons.warning)]);
    } else {
      return null;
    }
  }

  Widget _buildTile(Messages sms) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
          title: Text(
            sms.number,
            style: TextStyle(fontSize: 20.0),
          ),
          
          subtitle: Column(
            children:[
              Text(sms.result_number + sms.result_message,
                    style: TextStyle(fontSize: 15.0)),
              Text(sms.message,
                    style: TextStyle(fontSize: 13.0))     
                    ]
            ),

          trailing: _buildIcon(sms.rating_number, sms.rating_sms),
          onTap: () {
            _showMyDialog(sms);
          }),
    );
  }

  //When the user clicks on a tile, a dialog box opens.
  //TODO: make it so that tapping the Yes or No button updates the information of the message in the database.
  //TODO: make a drop-down menu for user to select which type of spam
  Future<void> _showMyDialog(Messages sms) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Is this message spam? If so, the sender will be marked as spam.'),
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
                    sms.rating_sms = 2;
                    sms.rating_number = 2;
                    DBProvider.db.updateData(sms, 'messages');
                    _getData();
                    String add_number = sms.number;
                    String add_message = sms.message;
                    GetPostApi(link: '/addphonenumber?number=$add_number')
                        .fetchPost();
                    GetPostApi(link: '/spamupdate?sms=$add_message&rating=ham')
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
                    sms.rating_sms = 1;
                    sms.rating_number = 1;
                    DBProvider.db.updateData(sms, 'messages');
                    _getData();
                    String add_message = sms.message;
                    GetPostApi(link: '/spamupdate?sms=$add_message&rating=spam')
                        .fetchPost();
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
