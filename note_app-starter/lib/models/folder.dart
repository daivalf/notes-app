import 'package:note_app/models/note.dart';

class Folder {
  String name;
  List <Note> notes;

  Folder(
    this.name,
    this.notes,
  );

  // get filteredNotes => null;
}