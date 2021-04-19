import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class GetPostApi {
  String link;
  GetPostApi({@required this.link});

  Future<Post> fetchPost() async {
    print('https://alerte-anti-arnaqueurs.glitch.me/'+link);
    final response = await http.get(Uri.parse(
        'https://alerte-anti-arnaqueurs.glitch.me/'+link));
    print('Sent');
    var post = Post.fromJson(json.decode(response.body));
    print(post.title);
    return post;
  }
}

class Post {
  final String title;
  Post({this.title});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'],
    );
  }
}
