import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//CHANGED RATING FROM STRING TO AN ID: 1 OR 0.

class GetPostApi {
  String link;
  GetPostApi({@required this.link});

  Future<Post> fetchPost() async {
    final response =
        await http.get(Uri.parse('https://serveronrepl.xinlei.repl.co' + link));
    print(
        'Successfully sent at' + ' https://serveronrepl.xinlei.repl.co' + link);
    var post = Post.fromJson(json.decode(response.body));
    print("AAAAA" + post.markedNum.toString());
    return post;
  }
}

class Post {
  final String messageNum;
  final String messageSms;
  final int ratingNum;
  final int ratingSms;
<<<<<<< HEAD
  int markedNum;
  Post(
      {this.messageNum,
      this.messageSms,
      this.ratingNum,
      this.ratingSms,
      this.markedNum});
=======
  final int markedNum;
  Post({this.messageNum, this.messageSms, this.ratingNum, this.ratingSms, this.markedNum});
>>>>>>> parent of 9d64b11 (changed the messages)
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      messageNum: json['message_num'],
      ratingNum: json['rating_num'],
      messageSms: json['message_sms'],
      ratingSms: json['rating_sms'],
      markedNum: json["was_marked"],
    );
  }
}
