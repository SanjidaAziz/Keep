import 'package:flutter/material.dart';
import 'package:keep/screens/notes_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: NotePage(),
    );
  }
}




