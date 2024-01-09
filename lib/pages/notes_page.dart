import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/components/drawer_custom.dart';
import 'package:simple_notes/components/textfield_custom.dart';
import 'package:simple_notes/models/note.dart';
import 'package:simple_notes/models/note_db.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final textController = TextEditingController();
  late FocusNode focusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //on startup read current notes
    readNotes();

    focusNode = FocusNode();
  }

  //create a note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add a note'),
        content: TextField_Custom(
          textController: textController,
          focusNode: focusNode,
        ),
        // action buttons
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              String textFromUser = textController.text;

              if (textFromUser.trim().isNotEmpty) {
                // add to db
                context.read<NoteDatabase>().addNote(textFromUser.trim());

                //clear textediting controller
                textController.clear();

                //pop the dialog
                Navigator.pop(context);

                print('saved!');
              } else {
                print('empty');
                focusNode.requestFocus();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  //read notes
  Future<void> readNotes() async {
    await context.read<NoteDatabase>().fetchNotes();
  }

  //update a note
  void updateNote(Note note) {
    //preload text to textfiled
    textController.text = note.text;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update note'),
        content: TextField_Custom(
          textController: textController,
          focusNode: focusNode,
        ),
        // action buttons
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              String textFromUser = textController.text;

              if (textFromUser.trim().isNotEmpty) {
                // add to db
                context
                    .read<NoteDatabase>()
                    .updateNote(note.id, textFromUser.trim());

                //clear textediting controller
                textController.clear();

                //pop the dialog
                Navigator.pop(context);

                print('updated!');
              } else {
                print('empty');
                focusNode.requestFocus();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).then((value) => textController.clear());
  }

  //delete a note
  void deleteNote(Note note) {
    context.read<NoteDatabase>().deleteNote(note.id);
  }

  @override
  Widget build(BuildContext context) {
    // note database
    final noteDatabase = context.watch<NoteDatabase>();

    //current notes
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Simple Notes',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: const Icon(Icons.add),
      ),
      drawer: const Drawer_Custom(),
      body: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        color: Theme.of(context).primaryColor,
        child: RefreshIndicator(
          onRefresh: readNotes,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: currentNotes.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              //get individual note
              final note = currentNotes[index];
              if (currentNotes.isNotEmpty) {
                //current tile UI
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 239, 84, 33),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 8),
                    child: const Icon(Icons.delete_outline_rounded,
                        color: Colors.white),
                  ),
                  onDismissed: (_) async {
                    bool isUndoClicked = false;
                    //hide from list
                    var tempNote = currentNotes.removeAt(index);

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                          SnackBar(
                            content: const Text('The note has been removed.'),
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  //visible again in the list
                                  setState(() {
                                    currentNotes.insert(index, tempNote);
                                    isUndoClicked = true;
                                  });
                                }),
                            duration: const Duration(seconds: 3),
                          ),
                        )
                        .closed
                        .then((value) {
                      print(value);
                      //delete from db
                      if (isUndoClicked == false) {
                        deleteNote(note);
                        print('deleted!');
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: ListTile(
                        title: Text(note.text),
                        onTap: () => updateNote(note),
                      ),
                    ),
                  ),
                );
              } else {
                return const Text(
                    'Start by creating your first note to bring this canvas to life.');
              }
            },
          ),
        ),
      ),
    );
  }
}
