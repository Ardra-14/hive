import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_app/models/todo_model.dart';

class TodoService{

  Box<Todo>? _todoBox;

  Future<void> openBox() async{
    _todoBox = await Hive.openBox<Todo>('todos');
  }
  
  Future <void> closeBox() async{
    await _todoBox!.close();
  }


  //add todo

  Future<void> addTodo(Todo todo) async{
    if(_todoBox == null){
      await openBox();
    }
    await _todoBox!.add(todo);
  }

  //get todos
  Future<List<Todo>>getTodos() async{
    if(_todoBox == null){
      await openBox();
    }
    return _todoBox!.values.toList();
  }

  //UPDATE TODO
  Future <void> updateTodo(int index,Todo todo) async{
    if(_todoBox == null){
      await openBox();
    }
    await _todoBox!.putAt(index, todo);
  }

  //delete Todo

  Future <void> delete(int index) async{
    if(_todoBox == null){
      await openBox();
    }
    await _todoBox!.deleteAt(index);
  }
}