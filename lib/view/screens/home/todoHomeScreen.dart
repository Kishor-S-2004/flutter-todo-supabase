import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_project/model/todoModel.dart';
import 'package:todo_project/services/todo_services.dart';
import 'package:todo_project/view/widget/todoWidgets.dart';
import 'package:todo_project/viewModel/todoProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final TodoServices todoServices = TodoServices();

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'My Todos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          _controller.clear();

          showDialog(
            context: context,
            builder: (_) =>
                TodoShowDialog(controller: _controller, isEdit: false),
          );
        },
        child: const Icon(Icons.add,color: Colors.white,),
      ),

      body: user == null
          ? const Center(child: Text('User not logged in'))
          : StreamBuilder<List<TodoModel>>(
              stream: todoServices.getTodos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final todos = snapshot.data ?? [];

                final userTodos = todos
                    .where((t) => t.userId == user.id)
                    .toList();

                if (userTodos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.note_alt_outlined,
                            size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 10),
                        Text(
                          'No todos yet',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: userTodos.length,
                  itemBuilder: (context, index) {
                    final todo = userTodos[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: todo.isCompleted!
                            ? Colors.grey.shade200
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

                        title: Text(
                          todo.todoContent!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            decoration: todo.isCompleted!
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: todo.isCompleted!
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),

                        leading: GestureDetector(
                          onTap: () {
                            todoServices.completedTodo(
                                todo, !todo.isCompleted!);
                          },
                          child: Icon(
                            todo.isCompleted!
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: todo.isCompleted!
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),

                        trailing: IconButton(
                          onPressed: () {
                            todo.isCompleted!
                                ? todoServices.deleteTodo(todo)
                                : showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: const Text('Delete Todo'),
                                content: const Text(
                                    'Are you sure you want to delete this todo?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      todoServices.deleteTodo(todo);
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
