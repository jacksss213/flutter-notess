part of 'notes_bloc.dart';

@immutable
sealed class NotesState {
  final List<Notes> notes;

  const NotesState(this.notes);
}

final class NotesInitial extends NotesState {
  const NotesInitial(super.notes);
}

final class NotesAdded extends NotesState {
  NotesAdded(super.notes);
}

final class NotesRemoved extends NotesState {
  NotesRemoved(super.notes);
}

final class NotesUpdated extends NotesState {
  NotesUpdated(super.notes);
}

final class NotesAuthentication extends NotesState {
  NotesAuthentication(super.notes);
}
