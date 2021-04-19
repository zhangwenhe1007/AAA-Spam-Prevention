import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './networking.dart';


class PageTwo extends StatefulWidget {
  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();

  static const _channel2 =
      BasicMessageChannel('com.appSms/demo', StringCodec());
  static const _channel3 =
      BasicMessageChannel('com.appSender/demo', StringCodec());
  String link = "";
  String _smsMessage = "";
  String _senderNumber = "";
  String _smsResult = "";
  int iconState = 0;

  @override
  void initState() {
    super.initState();
    var androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    localNotification.initialize(initializationSettings,
        onSelectNotification: onSelectNotif);
    _channel2.setMessageHandler((String message) async {
      message = message.replaceAll(new RegExp(r'[^\w\s]+'), '');
      print("Received SMS = $message");
      setState(() {
        _smsMessage = message;
        iconState = 1;
      });
      link = 'message?sms=$_smsMessage';
        var api = GetPostApi(link: link);
        api.fetchPost().then((post) {
          setState(() {
            _smsResult = post.title.toString();
          });
        }, onError: (error) {
          setState(() {
            _smsResult = error.toString();
          });
        });
      return 'OK';
    });
    _channel3.setMessageHandler((String message) async {
      message = message.replaceAll(new RegExp(r'[^\w\s]+'), '');
      print("Received phone number of sender = $message");
      setState(() {
        _senderNumber = message;
      });
      print(_senderNumber);
      showNotification('Alert','You have received a spam message from' + _senderNumber);
      return 'OK';
    });
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
    await localNotification.show(
      0,
      '$notifTitle',
      '$notifMessage',
      generalNotificationDetails,
      payload: 'WELCOME TO THE NOTIFICATION CHANNEL',
    );
  }

  Future onSelectNotif(String payload) async {
    print('This was selected');
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
        title: Text('Incoming SMS'),
      ),
      body: ListView(
        children: <Widget>[_buildPage(_smsMessage,_senderNumber + _smsResult)],
      ),
    );
  }

  Widget _buildIcon() {
    if (iconState == 1) {
      return Icon(Icons.check);
    } else if (iconState == 2) {
      return Icon(Icons.warning);
    }
  }

  Widget _buildPage(String text, String subtext) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
          title: Text(text, style: TextStyle(fontSize: 24.0)),
          trailing: _buildIcon(),
          subtitle: Text(subtext),
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
                Text('Is this SMS a spam message?'),
                Text('If you click "Yes", the sender will be marked as a spam number.'),
              ],
            ),
          ),
          actions: <Widget>[
            //FIX BUTTON POSITION ACCORDING TO WIDTH OF SCREEN
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
