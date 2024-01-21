import 'package:flutter/material.dart';

class ExpansionTile_Custom extends StatelessWidget {
  const ExpansionTile_Custom(
      {super.key, required this.question, required this.answer});
  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(question),
      childrenPadding: const EdgeInsets.only(
        top: 8,
        bottom: 8.0,
      ),
      tilePadding: const EdgeInsets.all(0),
      expandedAlignment: Alignment.centerLeft,
      children: [
        Text(
          answer,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
