import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_list/features/tasks/interfaces/task_cubit_interface.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';
import 'missed_tasks_cubit.dart';
import 'completed_tasks_cubit.dart';

class ActiveTasksCubit extends Cubit<List<Task>> implements TaskCubitInterface {
  final MissedTasksCubit missedTasksCubit;
  final CompletedTasksCubit completedTasksCubit;
  final Box<Task> box;

  Timer? _timer;

  ActiveTasksCubit(
      {required this.missedTasksCubit,
      required this.completedTasksCubit,
      required this.box})
      : super(box.values.toList()) {
    _startTimerIfNeeded();
  }

  @override
  Future<void> addTask(Task task) async {
    await box.put(task.id, task);
    emit([...state, task]);
    _startTimerIfNeeded();
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
    _stopTimerIfNeeded();
  }

  Future<void> markAsDone(Task task) async {
    await removeTask(task);
    final completedTask = task.copyWith(status: TaskStatus.completed);
    await completedTasksCubit.addTask(completedTask);
  }

  void _startTimerIfNeeded() {
    if (_timer != null && _timer!.isActive) return;
    if (state.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  void _stopTimerIfNeeded() {
    if (state.isEmpty) {
      _timer?.cancel();
      _timer = null;
    }
  }

  void _onTick() async {
    final now = DateTime.now();

    final expired = state
        .where((t) => t.status == TaskStatus.active && t.deadline.isBefore(now))
        .toList();

    if (expired.isNotEmpty) {
      // Skapa nya Missed-tasks
      final missedTasks =
          expired.map((t) => t.copyWith(status: TaskStatus.missed)).toList();

      // Uppdatera Hive: ta bort från activeBox
      await box.deleteAll(expired.map((t) => t.id));

      // Lägg till i MissedTasksCubit (sparas till Hive där)
      for (var missed in missedTasks) {
        await missedTasksCubit.addTask(missed);
      }

      // Uppdatera state
      final stillActive = state.where((t) => !expired.contains(t)).toList();

      emit(stillActive);
    } else {
      // Uppdatera UI med samma state så timern tickar visuellt
      emit(List.from(state));
    }

    _stopTimerIfNeeded();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
