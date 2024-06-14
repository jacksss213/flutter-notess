part of 'form_validation_bloc.dart';

@immutable
sealed class FormValidationEvent {}

class OnFormValidationInitial extends FormValidationEvent {}

class OnFormValidationLogin extends FormValidationEvent {
  final String username;
  final String password;

  OnFormValidationLogin(this.username, this.password);
}

class OnFormValidationRegister extends FormValidationEvent {
  final String username;
  final String password;

  OnFormValidationRegister(this.username, this.password);
}
