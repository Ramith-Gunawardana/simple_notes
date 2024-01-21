import 'package:flutter/material.dart';
import 'dart:math';

class TextField_Custom extends StatelessWidget {
  const TextField_Custom(
      {required this.textController,
      required this.focusNode,
      required this.undoController,
      super.key});
  final TextEditingController textController;
  final FocusNode focusNode;
  final UndoHistoryController undoController;

  @override
  Widget build(BuildContext context) {
    List<String> hintTexts = [
      'What\'s on your mind?',
      'Type your note here...',
      'Jot down your ideas..',
      'Capture your thoughts...',
      'Start typing your note...',
      'Compose your thoughts...',
      'Unleash your imagination...',
      'Time to pen your ideas...',
      'Let the ideas flow...',
    ];
    int randomIndex = Random().nextInt(hintTexts.length);

    return TextField(
      controller: textController,
      focusNode: focusNode,
      expands: true,
      minLines: null,
      maxLines: null,
      decoration: InputDecoration(
        hintText: hintTexts[randomIndex],
        filled: true,
        border: InputBorder.none,
        fillColor: Colors.transparent,
        // border: const OutlineInputBorder(
        //   borderRadius: BorderRadius.all(
        //     Radius.circular(18),
        //   ),
        // ),
      ),
      undoController: undoController,
    );
  }
}
