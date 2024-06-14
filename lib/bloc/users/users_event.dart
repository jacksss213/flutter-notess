part of 'users_bloc.dart';

@immutable
sealed class UsersEvent {}

class OnFetchUsers extends UsersEvent {}

class OnInitialUsers extends UsersEvent {}

class OnAddUsers extends UsersEvent {
  final Users newUsers;

  OnAddUsers(this.newUsers);
}

class OnRemoveUsers extends UsersEvent {
  final int index;

  OnRemoveUsers(this.index);
}

class OnUpdateUsers extends UsersEvent {
  final Users newUsers;
  final int index;

  OnUpdateUsers(this.newUsers, this.index);
}

class OnAuthentication extends UsersEvent {
  final String username;
  final String password;

  OnAuthentication(this.username, this.password);
}
