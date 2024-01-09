import 'package:flutter/material.dart';
import 'dart:math';

class TextField_Custom extends StatelessWidget {
  const TextField_Custom(
      {required this.textController, required this.focusNode, super.key});
  final TextEditingController textController;
  final FocusNode focusNode;

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
      decoration: InputDecoration(
        hintText: hintTexts[randomIndex],
        filled: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
        ),
      ),
    );
  }
}
