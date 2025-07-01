import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:focus_list/features/tasks/interfaces/task_cubit_interface.dart';
import '../models/task.dart';

class MissedTasksCubit extends Cubit<List<Task>> implements TaskCubitInterface {
  final Box<Task> box;

  MissedTasksCubit(this.box) : super(box.values.toList());

  @override
  Future<void> addTask(Task task) async {
    await box.put(task.id, task);
    emit(box.values.toList());
  }

  @override
  Future<void> editTask(Task updatedTask) async {
    await box.put(updatedTask.id, updatedTask);
    emit(box.values.toList());
  }

  @override
  Future<void> removeTask(Task task) async {
    await box.delete(task.id);
    emit(box.values.toList());
  }
}
