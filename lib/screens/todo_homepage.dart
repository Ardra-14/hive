import 'package:flutter/material.dart';
import 'package:my_app/models/todo_model.dart';
import 'package:my_app/services/todo_service.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  final TodoService _todoService = TodoService();//instance of TodoService
  List<Todo>_todos = [];


//loading all todos -> fetching all data from hive

Future<void> _loadTodos() async{
  _todos = await _todoService.getTodos();
  setState(() {
    
  });
}


@override
  void initState() {
    _loadTodos();
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //dialog for adding a todo
          showAddDialog();
      },
      child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('All Tasks'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: _todos.length,
          itemBuilder: (context, index){

            final todo = _todos[index];

          return Card(
            elevation: 5.0,

            child: ListTile(
              
              onTap: (){
                //edit dialog
                _showEditDialog(todo,index);
              },
              title: Text('${todo.title}'),
              subtitle: Text('${todo.description}'),
              trailing: Container(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Checkbox(
                      value: todo.completed, 
                      onChanged: (value){
                        setState(() {
                          todo.completed = value!;
                          //update the hive db 
                          _todoService.updateTodo(index, todo);
                          setState(() {
                            
                          });
                    
                        });
                      }
                      ),
                      IconButton(onPressed: ()async{
                       await  _todoService.delete(index);
                       _loadTodos();
                      }, icon: Icon(Icons.delete))
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }



  Future <void> showAddDialog () async{
    await showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Add New Task'),
        content : Container(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Title"
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: _descController,
                decoration: InputDecoration(
                  hintText: "Description"
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(onPressed: (){}, child: Text('Cancel')),
          ElevatedButton(onPressed: ()async{

            //create a new todo model

            final newTodo = Todo(
              title: _titleController.text, 
              description: _descController.text, 
              createdAt: DateTime.now(), 
              completed: false
              );
              await _todoService.addTodo(newTodo);
              _titleController.clear();
              _descController.clear();

              Navigator.pop(context);

              _loadTodos();

          },
           child: Text('Add')),
         
        ],
      );
    });
  }


  Future<void> _showEditDialog(Todo todo, int index) async{
    _titleController.text = todo.title;
    _descController.text = todo.description;
    await showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Add New Task'),
        content : Container(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Title"
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: _descController,
                decoration: InputDecoration(
                  hintText: "Description"
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(onPressed: (){}, child: Text('Cancel')),
          ElevatedButton(onPressed: ()async{

           todo.title = _titleController.text;
           todo.description = _descController.text;
           todo.createdAt = DateTime.now();

           if(todo.completed == true){
            todo.completed == false;
           }
          await _todoService.updateTodo(index, todo);

            _titleController.clear();
            _descController.clear();

            Navigator.pop(context);

            _loadTodos();


          },
           child: Text('Update')),
         
        ],
      );
    });
  }
}