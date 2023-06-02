import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/cubit/states.dart';
import 'package:notes_app/note_model.dart';

class NoteCubit extends Cubit<NoteStates> {
  NoteCubit() : super(InitialNotesState());

  static NoteCubit get(context) => BlocProvider.of(context);

  Future<void> AddNote(NoteModel model) async {
    emit(AddNoteLoadingState());
    try {
      var notesbox = Hive.box<NoteModel>('notes');
      await notesbox.add(model);
      getNote();
      emit(AddNoteSuccessState());
    } catch (e) {
      print(e.toString());
      emit(AddNoteErrorState());
    }
  }

  List<NoteModel>? notes;
  void getNote() async {
    emit(GetNoteLoadingState());
    try {
      var notesbox = Hive.box<NoteModel>('notes');
      notes = notesbox.values.toList();
      emit(GetNoteSuccessState());
    } catch (e) {
      print(e.toString());
      emit(GetNoteErrorState());
    }
  }

  void deleteNote(NoteModel model) async {
    emit(DeleteNoteLoadingState());
    try {
      await model.delete();
      getNote();
      emit(DeleteNoteSuccessState());
    } catch (e) {
      print(e.toString());
      emit(DeleteNoteErrorState());
    }
  }

  void updateNote(NoteModel model, String title, String details) async {
    emit(UpdateNoteLoadingState());
    try {
      model.title = title;
      model.subTitle = details;
      await model.save();
      getNote();
      emit(UpdateNoteSuccessState());
    } catch (e) {
      print(e.toString());
      emit(UpdateNoteErrorState());
    }
  }

  int selectedindex = 0;
  void changeColor(index) {
    selectedindex = index;
    emit(ChangeColorState());
  }
}
