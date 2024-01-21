import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/components/textfield_custom.dart';
import 'package:simple_notes/models/note_db.dart';
import 'package:simple_notes/pages/notes_page.dart';

class ViewNote extends StatefulWidget {
  final String title;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final UndoHistoryController undoController;
  final String type;
  final int noteID;

  const ViewNote({
    super.key,
    required this.title,
    required this.textEditingController,
    required this.focusNode,
    required this.undoController,
    required this.type,
    required this.noteID,
  });

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          if (widget.type == 'create') {
            String textFromUser = widget.textEditingController.text;

            if (textFromUser.trim().isNotEmpty) {
              // add to db
              context.read<NoteDatabase>().addNote(textFromUser.trim());
              print('saved!');

              //pop the dialog
              // Navigator.pop(context);
              Future.delayed(Duration.zero, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotesPage(),
                  ),
                );
                Navigator.pop(context);
              });

              //clear textediting controller
              widget.textEditingController.clear();
            } else {
              print('empty');
              widget.focusNode.requestFocus();
            }
          } else if (widget.type == 'update') {
            String textFromUser = widget.textEditingController.text;

            if (textFromUser.trim().isNotEmpty) {
              // add to db
              context
                  .read<NoteDatabase>()
                  .updateNote(widget.noteID, textFromUser.trim());

              //pop the dialog
              // Navigator.pop(context);
              Future.delayed(Duration.zero, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotesPage(),
                  ),
                );
                Navigator.pop(context);
              });

              print('updated!');

              //clear textediting controller
              widget.textEditingController.clear();
            } else {
              print('empty and deleted');

              context.read<NoteDatabase>().deleteNote(widget.noteID);
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            ValueListenableBuilder<UndoHistoryValue>(
              valueListenable: widget.undoController,
              builder: (context, value, child) {
                return IconButton(
                  onPressed: value.canUndo
                      ? () {
                          widget.undoController.undo();
                        }
                      : null,
                  icon: const Icon(Icons.undo_rounded),
                  tooltip: 'Undo',
                );
              },
            ),
            ValueListenableBuilder<UndoHistoryValue>(
              valueListenable: widget.undoController,
              builder: (context, value, child) {
                return IconButton(
                  onPressed: value.canRedo
                      ? () {
                          widget.undoController.redo();
                        }
                      : null,
                  icon: const Icon(Icons.redo_rounded),
                  tooltip: 'Redo',
                );
              },
            ),
            PopupMenuButton(
              position: PopupMenuPosition.under,
              tooltip: 'More options',
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(Icons.clear_rounded),
                        SizedBox(width: 12),
                        Text('Clear all'),
                      ],
                    ),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  widget.textEditingController.clear();
                }
              },
            ),
          ],
        ),
        body: TextField_Custom(
          textController: widget.textEditingController,
          focusNode: widget.focusNode,
          undoController: widget.undoController,
        ),
      ),
    );
  }
}
