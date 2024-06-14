import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_test/models/notes.dart';
import 'package:interview_test/source/storage_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(NotesInitial([])) {
    on<OnFetchNotes>((event, emit) async {
      List<Notes> result = await StorageSource.getAllNotes();
      List<Notes> oldNotes = state.notes;

      if (oldNotes.length == 0) {
        result!.forEach((value) {
          emit(NotesAdded(
            [...state.notes, value],
          ));
        });
      }
    });

    on<OnAddNotes>((event, emit) async {
      Notes newNotes = event.newNotes;

      //save data to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('notes_${newNotes.id}', <String>[
        newNotes.id.toString(),
        newNotes.title,
        newNotes.description,
        newNotes.descriptionConvert,
        newNotes.time,
        newNotes.date,
        newNotes.user_id,
        newNotes.created_at
      ]);

      emit(NotesAdded(
        [...state.notes, newNotes],
      ));
    });

    on<OnUpdateNotes>((event, emit) async {
      int index = event.index;
      List<Notes> notesUpdated = state.notes;
      Notes newNote = Notes(
          notesUpdated[index].id,
          event.newNotes.title,
          event.newNotes.description,
          event.newNotes.descriptionConvert,
          event.newNotes.time,
          event.newNotes.date,
          event.newNotes.user_id,
          notesUpdated[index].created_at);

      notesUpdated[index] = newNote;

      //save data to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('notes_${newNote.id}', <String>[
        newNote.id.toString(),
        newNote.title,
        newNote.description,
        newNote.descriptionConvert,
        newNote.time,
        newNote.date,
        newNote.user_id,
        notesUpdated[index].created_at
      ]);

      emit(NotesUpdated(notesUpdated));
    });

    on<OnRemoveNotes>((event, emit) async {
      int index = event.index;
      List<Notes> notesRemoved = state.notes;

      //remove data to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('notes_${notesRemoved[index].id}');

      notesRemoved.removeAt(index);

      emit(NotesUpdated(notesRemoved));
    });

    on<OnLogoutNotes>((event, emit) async {
      state.notes.clear();
    });
  }
}
