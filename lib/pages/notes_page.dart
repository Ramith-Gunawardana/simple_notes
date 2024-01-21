import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/components/drawer_custom.dart';
import 'package:simple_notes/components/expansion_tile_custom.dart';
import 'package:simple_notes/components/textfield_custom.dart';
import 'package:simple_notes/models/note.dart';
import 'package:simple_notes/models/note_db.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_notes/pages/view_note.dart';
import 'package:url_launcher/url_launcher.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final textController = TextEditingController();
  late FocusNode focusNode;
  final UndoHistoryController undoController = UndoHistoryController();

  final Uri _url = Uri.parse('https://ramith-gunawardana.github.io/');

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //on startup read current notes
    readNotes();

    focusNode = FocusNode();

    //get version number
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  //create a note
  void createNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewNote(
          title: 'Add a note',
          textEditingController: textController,
          focusNode: focusNode,
          undoController: undoController,
          type: 'create',
          noteID: 0,
        ),
      ),
    );
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: const Text('Add a note'),
    //     content: TextField_Custom(
    //       textController: textController,
    //       focusNode: focusNode,
    //     ),
    //     // action buttons
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Navigator.pop(context);
    //         },
    //         child: const Text('Cancel'),
    //       ),
    //       FilledButton(
    //         onPressed: () {
    //           String textFromUser = textController.text;

    //           if (textFromUser.trim().isNotEmpty) {
    //             // add to db
    //             context.read<NoteDatabase>().addNote(textFromUser.trim());

    //             //clear textediting controller
    //             textController.clear();

    //             //pop the dialog
    //             Navigator.pop(context);

    //             print('saved!');
    //           } else {
    //             print('empty');
    //             focusNode.requestFocus();
    //           }
    //         },
    //         child: const Text('Save'),
    //       ),
    //     ],
    //   ),
    // );
  }

  //read notes
  Future<void> readNotes() async {
    await context.read<NoteDatabase>().fetchNotes();
  }

  //update a note
  void updateNote(Note note) {
    //preload text to textfiled
    textController.text = note.text;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewNote(
          title: 'Update note',
          textEditingController: textController,
          focusNode: focusNode,
          undoController: undoController,
          type: 'update',
          noteID: note.id,
        ),
      ),
    );

    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: const Text('Update note'),
    //     // content: TextField_Custom(
    //     //   textController: textController,
    //     //   focusNode: focusNode,
    //     // ),
    //     // action buttons
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Navigator.pop(context);
    //         },
    //         child: const Text('Cancel'),
    //       ),
    //       FilledButton(
    //         onPressed: () {
    //           String textFromUser = textController.text;

    //           if (textFromUser.trim().isNotEmpty) {
    //             // add to db
    //             context
    //                 .read<NoteDatabase>()
    //                 .updateNote(note.id, textFromUser.trim());

    //             //clear textediting controller
    //             textController.clear();

    //             //pop the dialog
    //             Navigator.pop(context);

    //             print('updated!');
    //           } else {
    //             print('empty');
    //             focusNode.requestFocus();
    //           }
    //         },
    //         child: const Text('Save'),
    //       ),
    //     ],
    //   ),
    // ).then((value) => textController.clear());
  }

  //delete a note
  void deleteNote(Note note) {
    context.read<NoteDatabase>().deleteNote(note.id);
  }

  void faq() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Frequently Asked Questions'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExpansionTile_Custom(
              question: 'How to create a new note?',
              answer: 'Tap the + icon on the bottom right corner',
            ),
            ExpansionTile_Custom(
              question: 'How to update a note?',
              answer: 'Tap on the note and make the changes. Then hit save!',
            ),
            ExpansionTile_Custom(
              question: 'How to delete a note?',
              answer: '<<<<<<<<<  Swipe left on the note. <<<<<<<<<',
            ),
            ExpansionTile_Custom(
              question: 'How to recover an accidently deleted note?',
              answer:
                  'Tap \'Undo\' on the card which display when deleting the note. After 3 seconds it will dissapear and you cannot recover afterwards.',
            ),
          ],
        ),
        actions: [
          FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'))
        ],
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(
      _url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $_url');
    }
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
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            tooltip: 'More options',
            itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.help_outline_rounded),
                      SizedBox(width: 12),
                      Text('FAQ'),
                    ],
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded),
                      SizedBox(width: 12),
                      Text('About'),
                    ],
                  ),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
                faq();
              } else if (value == 1) {
                showDialog(
                  context: context,
                  builder: (context) => AboutDialog(
                    applicationIcon: const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('lib/assets/icon.png'),
                      ),
                    ),
                    applicationName: 'Simple Notes',
                    applicationVersion: _packageInfo.version,
                    children: [
                      const Text('Made with 💛 by Ramith Gunawardana'),
                      const SizedBox(height: 12),
                      InkWell(
                          onTap: _launchUrl,
                          child: Text(
                            'Connect with me',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ],
                    // ExactAssetImage('lib/assets/notes.png')
                    //   title: const Text('About Simple Notes'),
                    //   content: Column(
                    //     mainAxisSize: MainAxisSize.min,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text('Version: ${_packageInfo.version}'),
                    //       const SizedBox(height: 24),
                    //       const Text('Made with ❤️ by Ramith Gunawardana'),
                    //       const SizedBox(height: 12),
                    //       const Text('Powered by Flutter'),
                    //     ],
                    //   ),
                    //   actions: [
                    //     FilledButton(
                    //         onPressed: () {
                    //           ScaffoldMessenger.of(context).showSnackBar(
                    //             const SnackBar(
                    //               content: Text(
                    //                 '^_^',
                    //                 textAlign: TextAlign.center,
                    //               ),
                    //               backgroundColor:
                    //                   Color.fromARGB(255, 165, 124, 0),
                    //               behavior: SnackBarBehavior.floating,
                    //               width: 60,
                    //               duration: Duration(seconds: 1),
                    //             ),
                    //           );
                    //           Navigator.pop(context);
                    //         },
                    //         child: const Text('Ok'))
                    //   ],
                  ),
                );
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: const Icon(Icons.add),
      ),
      // drawer: const Drawer_Custom(),
      body: GlowingOverscrollIndicator(
        showLeading: false,
        axisDirection: AxisDirection.down,
        color: Theme.of(context).primaryColor,
        child: RefreshIndicator(
          onRefresh: readNotes,
          child: currentNotes.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: currentNotes.length,
                  shrinkWrap: false,
                  itemBuilder: (context, index) {
                    //get individual note
                    final note = currentNotes[index];
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
                                content:
                                    const Text('The note has been removed.'),
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
                            // color: Theme.of(context).colorScheme.inversePrimary,
                            border: Border.all(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            type: MaterialType.canvas,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              // splashColor:
                              //     const Color.fromARGB(124, 194, 142, 1),
                              onTap: () {
                                updateNote(note);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 12),
                                child: ListTile(
                                  title: Text(note.text),
                                  // onTap: () => updateNote(note),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage('lib/assets/empty_notes.gif'),
                          height: 120,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          'It seems like empty here...',
                          textAlign: TextAlign.start,
                          textScaler: TextScaler.linear(1.2),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.help_outline_rounded),
                          onPressed: faq,
                          label: const Text('How to use'),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        FilledButton.icon(
                            icon: const Icon(Icons.add),
                            onPressed: createNote,
                            label: const Text('Add a note')),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
