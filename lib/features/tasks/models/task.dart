enum TaskStatus { active, completed, missed, paused }

class Task {
  String id;
  String title;
  DateTime createdAt;
  DateTime deadline;
  TaskStatus status;

  Task({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.deadline,
    this.status = TaskStatus.active,
  });

  Task copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? deadline,
    TaskStatus? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
    );
  }
}
