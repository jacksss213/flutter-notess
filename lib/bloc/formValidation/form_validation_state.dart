part of 'form_validation_bloc.dart';

@immutable
sealed class FormValidationState {
  final String username;
  final String password;

  FormValidationState(this.username, this.password);
}

final class FormValidationInitial extends FormValidationState {
  FormValidationInitial(super.username, super.password);
}

final class FormValidationLogin extends FormValidationState {
  FormValidationLogin(super.username, super.password);
}

final class FormValidationRegister extends FormValidationState {
  FormValidationRegister(super.username, super.password);
}
