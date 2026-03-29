import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_project/model/todoModel.dart';

class TodoServices {
  final database = Supabase.instance.client.from('To-Do');
  // final id = Supabase.instance.client.auth.currentUser;

  Future createTodo(TodoModel todoContent) async {
    await database.insert(todoContent.toJson());
  }

  Stream<List<TodoModel>> getTodos() {
    return database.stream(primaryKey: ['id']).map(
          (data) => data.map((e) => TodoModel.fromJson(e)).toList(),
    );
  }

  Future updateTodo(TodoModel oldTodo, String newTodo) async {
    await database.update({'todo': newTodo}).eq('id', oldTodo.id!);
  }

  Future completedTodo(TodoModel oldTodo, bool value) async {
    await database.update({'is_completed': value}).eq('id', oldTodo.id!);
  }

  Future deleteTodo(TodoModel todo) async {
    await database.delete().eq('id', todo.id!);
  }
}
