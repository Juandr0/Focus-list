import 'package:hive/hive.dart';
part 'task.g.dart';

@HiveType(typeId: 0)
enum TaskStatus {
  @HiveField(0)
  active,
  @HiveField(1)
  completed,
  @HiveField(2)
  missed
}

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  DateTime deadline;

  @HiveField(4)
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
