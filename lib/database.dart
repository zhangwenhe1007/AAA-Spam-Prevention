import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models/numbers.dart';
import 'models/messages.dart';


//The data base in the method

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  Future<Database> initDB() async {
    final database =  openDatabase(
        join(await getDatabasesPath(), 'numbers_database.db'),
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE numbers(number TEXT PRIMARY KEY, result TEXT, rating INTEGER, markedNum INTEGER)',
          );
          await db.execute(
            'CREATE TABLE messages(number TEXT PRIMARY KEY, message TEXT, result_number TEXT, result_message TEXT, ratingNumber INTEGER, ratingSMS INTEGER, markedNum INTEGER)',
          );
        },
        version: 1,
      );
    return database;
  }

  // Define a function that inserts data into the database
  insertData(object, String name) async {
    // Get a reference to the database.
    final db = await initDB();
    var res = await db.insert(
     '$name',
      object.toMap(), //We call the toMap method of any class of numbers or messages that we pass as argument to this function.
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Response is $res');
    return res;
  }

  Future<dynamic> getNumbers(String name) async {
    // Get a reference to the database.
    final db = await initDB();

    // Query the table for all The numbers.
    final List<Map<String, dynamic>> maps = await db.query('$name');
    if (maps.isEmpty) {
      print('This is empty');
      return null;
    } else {
      print('It is not empty');
      // Convert the List<Map<String, dynamic> into a List<Object>.
      if (name == 'numbers') {
         return List.generate(maps.length, (i) {
            return Numbers(
              number: maps[i]['number'],
              result: maps[i]['result'],
              rating: maps[i]['rating'],
              times_marked: maps[i]['markedNum'],
            );
          });
      } else {
        return List.generate(maps.length, (i) {
            return Messages(
              number: maps[i]['number'],
              result_number: maps[i]['result_number'],
              result_message: maps[i]['result_message'],
              rating_sms: maps[i]['ratingSMS'],
              rating_number: maps[i]['ratingNumber'],
              message: maps[i]['message'],
              times_marked: maps[i]['markedNum'],
            );
          });
      }
         
    }
  }


  Future<void> updateData(object, String name) async {
    // Get a reference to the database.
    final db = await initDB();
    await db.update(
      '$name',
      object.toMap(),
      where: 'number = ?',
      // Pass the object's id as a whereArg to prevent SQL injection.
      //Both Numbers and Messages has an instance field named number
      whereArgs: [object.number],
    );
  }
  
  /*
  Future<void> deleteDog(int id) async {
    // Get a reference to the database.
    final db = await initDB();

    // Remove the Dog from the database.
    await db.delete(
      'numbers',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  } */

}

