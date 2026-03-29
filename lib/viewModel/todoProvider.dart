import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_project/model/todoModel.dart';
import 'package:todo_project/services/todo_services.dart';

class TodoProvider extends ChangeNotifier {
  final TodoServices todoServices = TodoServices();
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  Future<void> addTodo(TodoModel todo) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      errorMessage = 'No user found';
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      errorMessage = null;
      successMessage = null;
      notifyListeners();

      final newTodo = TodoModel(
        userId: user.id,
        todoContent: todo.todoContent,
        isCompleted: todo.isCompleted,
      );

      await todoServices.createTodo(newTodo);

      successMessage = 'Todo added successfully';
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTodo(TodoModel todo, String newText) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      errorMessage = 'User not found';
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      errorMessage = null;
      successMessage = null;
      notifyListeners();

      await todoServices.updateTodo(todo, newText);

      successMessage = 'Todo updated';
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
