import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class GetPostApi {
  String link;
  GetPostApi({@required this.link});

  Future<Post> fetchPost() async {
    final response = await http.get(Uri.parse(
        'https://alerte-anti-arnaqueurs.herokuapp.com/'+link));
    print('Successfully sent at' + ' https://alerte-anti-arnaqueurs.herokuapp.com/'+link);
    var post = Post.fromJson(json.decode(response.body));
    return post;
  }
}

class Post {
  final String title;
  final String rating;
  Post({this.title, this.rating});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'],
      rating: json['rating'],
    );
  }
}
