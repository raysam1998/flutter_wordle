import 'package:flutter/material.dart';
import 'package:flutter_wordle/wordle/views/wordle_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Flutter wordle",
      debugShowCheckedModeBanner: false,
      theme : ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home : const WordleScreen(),
    );
  } 

}