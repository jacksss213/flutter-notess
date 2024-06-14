part of 'users_bloc.dart';

@immutable
sealed class UsersState {
  final List<Users> users;
  final String message;

  UsersState(this.users, this.message);
}

final class UsersInitial extends UsersState {
  UsersInitial(super.users, super.message);
}

final class UsersAdded extends UsersState {
  UsersAdded(super.users, super.message);
}

final class UsersRemoved extends UsersState {
  UsersRemoved(super.users, super.message);
}

final class UsersUpdated extends UsersState {
  UsersUpdated(super.users, super.message);
}

class UsersAuthentication extends UsersState {
  UsersAuthentication(super.users, super.message);
}
