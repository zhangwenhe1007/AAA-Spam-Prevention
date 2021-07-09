import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user_data.csv');
  }

  Future<List> readMessage() async {
    try {
      final file = await _localFile;
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
  }

  Future writeCounter(String result, String result1) async {
    final file = await _localFile;
    print(result);
    print(result1);
    file.writeAsStringSync("$result, $result1\r\n", mode: FileMode.writeOnlyAppend);
  }
}
