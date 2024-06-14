part of 'notes_bloc.dart';

@immutable
sealed class NotesEvent {}

class OnFetchNotes extends NotesEvent {}

class OnLogoutNotes extends NotesEvent {}

class OnAddNotes extends NotesEvent {
  final Notes newNotes;

  OnAddNotes(this.newNotes);
}

class OnRemoveNotes extends NotesEvent {
  final int index;

  OnRemoveNotes(this.index);
}

class OnUpdateNotes extends NotesEvent {
  final Notes newNotes;
  final int index;

  OnUpdateNotes(this.newNotes, this.index);
}
