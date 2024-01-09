import 'package:isar/isar.dart';

//need to gemerate file
part 'note.g.dart';
// then run: "dart run build_runner build" in terminal

@Collection() //add this before run "dart run build_runner build
class Note {
  Id id = Isar.autoIncrement;
  late String text;
}
