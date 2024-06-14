import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'form_validation_event.dart';
part 'form_validation_state.dart';

class FormValidationBloc
    extends Bloc<FormValidationEvent, FormValidationState> {
  FormValidationBloc() : super(FormValidationInitial('', '')) {
    on<OnFormValidationInitial>((event, emit) {
      emit(FormValidationInitial('', ''));
    });

    on<OnFormValidationLogin>((event, emit) {
      if (event.username == '') {
        emit(FormValidationLogin('Username Tidak Boleh Kosong', ''));
      } else if (event.password == '') {
        emit(FormValidationLogin('', 'Password Tidak Boleh Kosong'));
      } else if (event.username == '' && event.password == '') {
        emit(FormValidationLogin(
            'Username Tidak Boleh Kosong', 'Password Tidak Boleh Kosong'));
      } else {
        emit(FormValidationLogin('', ''));
      }
    });

    on<OnFormValidationRegister>((event, emit) {
      if (event.username == '') {
        emit(FormValidationRegister('Username Tidak Boleh Kosong', ''));
      } else if (event.password == '') {
        emit(FormValidationRegister('', 'Password Tidak Boleh Kosong'));
      } else if (event.username == '' && event.password == '') {
        emit(FormValidationRegister(
            'Username Tidak Boleh Kosong', 'Password Tidak Boleh Kosong'));
      } else {
        emit(FormValidationRegister('', ''));
      }
    });
  }
}
