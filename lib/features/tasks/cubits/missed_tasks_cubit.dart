import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_list/features/tasks/interfaces/task_cubit_interface.dart';
import '../models/task.dart';

class MissedTasksCubit extends Cubit<List<Task>> implements TaskCubitInterface {
  MissedTasksCubit() : super([]);

  @override
  void addTask(Task task) {
    emit([...state, task]);
  }

  @override
  void editTask(Task updatedTask) {
    emit(state.map((t) => t.id == updatedTask.id ? updatedTask : t).toList());
  }

  @override
  void removeTask(Task task) {
    emit(state.where((t) => t.id != task.id).toList());
  }
}
