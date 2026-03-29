class TodoModel {
  int? id;
  String? userId;
  String? todoContent;
  bool? isCompleted;

  TodoModel({
    this.id,
    this.userId,
    this.todoContent,
    this.isCompleted,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? '' ,
      todoContent: json['todo'] ?? '',
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id' : userId,
    'todo': todoContent,
    'is_completed': isCompleted,
  };
}
