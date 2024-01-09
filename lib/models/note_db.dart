import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_notes/models/note.dart';

//extended class 'ChangeNotifier' uses for state mgt
class NoteDatabase extends ChangeNotifier {
  //Isar object
  static late Isar isar;

  //initialize db
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NoteSchema],
      directory: dir.path,
    );
  }

  //list of notes
  final List<Note> currentNotes = [];

  //create
  Future<void> addNote(String textFromUser) async {
    //create a new note object
    final newNote = Note()..text = textFromUser;

    //save to db
    await isar.writeTxn(() => isar.notes.put(newNote));

    //refresh current notes(re-read)
    fetchNotes();
  }

  //read
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);

    //use for state mgt
    notifyListeners();
  }

  //update
  Future<void> updateNote(int id, String newTextFromUser) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newTextFromUser;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  //delete
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}
