import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_test/models/users.dart';
import 'package:interview_test/source/encypted.dart' as encrypt;
import 'package:interview_test/source/storage_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersInitial([], '')) {
    on<OnInitialUsers>((event, emit) async {
      final users = state.users;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.clear();
      final String? username = prefs.getString('username');

      emit(UsersInitial(users, username!));
    });

    on<OnFetchUsers>((event, emit) async {
      List<Users> result = await StorageSource.getAllUser();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? username = prefs.getString('username');

      result!.forEach((value) {
        emit(UsersAdded(
          [...state.users, value],
          username != null ? 'LoggedIn' : '',
        ));
      });
    });

    on<OnAddUsers>((event, emit) async {
      var encryptedPassword =
          encrypt.EncryptData.encryptAES(event.newUsers.password);
      Users newUsers = Users(event.newUsers.username, encryptedPassword);

      //save data to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('users_${newUsers.username}',
          <String>[newUsers.username, encryptedPassword]);

      emit(UsersAdded(
        [...state.users, newUsers],
        '',
      ));
    });

    on<OnAuthentication>((event, emit) async {
      final users = state.users;

      int index = users.indexWhere((e) =>
          e.username == event.username &&
          encrypt.EncryptData.decryptAES(e.password) == event.password);
      if (index == -1) {
        emit(UsersAuthentication(
            users, 'Masukan username & password dengan benar'));
      } else {
        //save data to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', event.username);

        emit(UsersAuthentication(users, ''));
      }
    });
  }
}
