import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_app/app.dart';
import 'package:my_app/models/todo_model.dart';
import 'package:my_app/services/todo_service.dart';

void main() async{
 await Hive.initFlutter();
 Hive.registerAdapter(TodoAdapter()); //registering adapter
 await TodoService().openBox();
 runApp(
    MyApp(),
  );
}