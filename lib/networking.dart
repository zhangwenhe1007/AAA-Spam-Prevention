import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//CHANGED RATING FROM STRING TO AN ID: 1 OR 0.

class GetPostApi {
  String link;
  GetPostApi({@required this.link});

  //This is a class method that retuns a Post object (defined by the class below)
  Future<Post> fetchPost() async {
    final response = await http.get(Uri.parse(
        'https://serveronrepl.xinlei.repl.co'+link));
    if (response.statusCode == 200) {
    print('Successfully sent at' + ' https://serveronrepl.xinlei.repl.co'+link);
    print('This is response body');
    print(response.body);
    var post = Post.fromJson(json.decode(response.body));
    print(post);
    return post;
    } else {
      return null;
    }
  }
    // print('error caught: $e');
    // var post = Post.fromJson(json.decode("{message_num: 'Networking Error', rating_num: 'Networking Error', message_sms: 'Networking Error', rating_sms: 'Networking Error'}"));
    // print('This is post');
    // print(Post.toString());
    // return post;
}

class Post {
  final String messageNum;
  final String messageSms;
  final int ratingNum;
  final int ratingSms;
  final int times_marked;
  Post(
      {this.messageNum,
      this.messageSms,
      this.ratingNum,
      this.ratingSms,
      this.times_marked,});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      messageNum: json['message_num'],
      ratingNum: json['rating_num'],
      messageSms: json['message_sms'],
      ratingSms: json['rating_sms'],
      times_marked: json['was_marked'],
    );
  }
}