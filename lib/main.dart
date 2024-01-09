import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/models/note_db.dart';
import 'package:simple_notes/pages/notes_page.dart';

void main() async {
  //initialize notes isar db
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.init();

  // runApp(const MyApp());  //default method

  //state mgt
  runApp(
    ChangeNotifierProvider(
      create: (context) => NoteDatabase(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  //Theme mode
  ThemeMode themeMode = ThemeMode.system;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Notes',
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 191, 0),
          brightness: Brightness.dark,
        ),
      ),
      actions: const <Type, Action<Intent>>{},
      themeMode: themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 191, 0),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const NotesPage(),
    );
  }
}
