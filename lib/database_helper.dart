import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todoo/models/todo.dart';
import 'models/task.dart';

class DatabaseHelper  {

  Future<Database> database() async {
      return openDatabase(
        join(await getDatabasesPath(), 'todo.db'),
        onCreate:(db , version) async {
           await db.execute("CREATE  TABLE todos (id INTEGER PRIMARY KEY, title TEXT, taskId INTERGER, isDone INTEGER)");
           await db.execute("CREATE  TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, description TEXT)");
        },
      
        version: 1,
      );
  }
  
  
  


  Future<int> insertTask(Task task) async {
    Database _db =  await database();
    int taskId = 0;
    // Task imported as a model
   await _db.insert('tasks', task.toMap(),conflictAlgorithm: ConflictAlgorithm.replace).then((value) => taskId = value);

   return taskId;
    
  }
  
    Future<void> insertTodo(Todo todo) async {
    Database _db =  await database();
    // Task imported as a model
    await _db.insert('todos', todo.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<void> updateTitle(int taskId,String title) async {
    Database _db =  await database();
    // Task imported as a model
    await _db.rawQuery("UPDATE tasks SET title = '$title' WHERE id='$taskId'");
  }

    Future<void> updateDescription(int taskId,String description) async {
    Database _db =  await database();
    // Task imported as a model
    await _db.rawQuery("UPDATE tasks SET description = '$description' WHERE id='$taskId'");
  }


    Future<void> updateTodo(int id,int isDone) async {
    Database _db =  await database();
    // Task imported as a model
    await _db.rawQuery("UPDATE todos SET isDone = '$isDone' WHERE id='$id'");
  }
  

  Future<void> deleteTask(int taskId) async {
  Database _db =  await database();
  // Task imported as a model
  await _db.rawQuery("DELETE FROM tasks WHERE id = $taskId");
  await _db.rawQuery("DELETE FROM todos WHERE taskId = $taskId");
  }

  
  
  

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String,dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(id:taskMap[index]['id'],title:taskMap[index]['title'],description:taskMap[index]['description']);
    });
  }


    Future<List<Todo>> getTodos(int? taskId) async {
    Database _db = await database();
    List<Map<String,dynamic>> todoMap = await _db.rawQuery("SELECT * FROM todos WHERE taskId = $taskId");
    return List.generate(todoMap.length, (index) {
      return Todo(id:todoMap[index]['id'],title:todoMap[index]['title'],taskId:todoMap[index]['taskId'],isDone: todoMap[index]['isDone']);
    });
  }






}