import 'package:flutter/material.dart';
import 'package:my_app/screens/todo_homepage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home : TodoScreen(),
    );
  }
}