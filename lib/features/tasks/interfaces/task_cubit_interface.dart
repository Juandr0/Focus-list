import 'package:focus_list/features/tasks/models/task.dart';

abstract class TaskCubitInterface {
  void addTask(Task task);
  void editTask(Task task);
  void removeTask(Task task);
}
