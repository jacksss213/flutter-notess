import 'dart:convert';

import 'package:d_method/d_method.dart';

import 'package:http/http.dart' as http;
import 'package:interview_test/models/notes.dart';
import 'package:interview_test/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageSource {
  static Future<List<Users>> getAllUser() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    var newStorage = [];
    List<Users> users = [];

    for (String key in keys) {
      newStorage.add(key);
    }

    newStorage.asMap().forEach((index, value) async {
      if (value.toString().contains('users_')) {
        List<String> result = prefs.getStringList(value.toString())!;
        users.add(Users(result[0], result[1]));
      }
    });

    return users;
  }

  static Future<List<Notes>> getAllNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');

    final keys = prefs.getKeys();
    var newStorage = [];
    List<Notes> notes = [];

    for (String key in keys) {
      newStorage.add(key);
    }

    newStorage.asMap().forEach((index, value) async {
      if (value.toString().contains('notes_')) {
        List<String> result = prefs.getStringList(value.toString())!;

        if (result[6] == username) {
          var id = int.parse(result[0]);
          assert(id is int);
          notes.add(Notes(id, result[1], result[2], result[3], result[4],
              result[5], result[6], result[7]));
        }
      }
    });

    return notes;
  }
}
