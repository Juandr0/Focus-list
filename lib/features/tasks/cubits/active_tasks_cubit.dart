import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task.dart';
import 'missed_tasks_cubit.dart';
import 'completed_tasks_cubit.dart';

class ActiveTasksCubit extends Cubit<List<Task>> {
  final MissedTasksCubit missedTasksCubit;
  final CompletedTasksCubit completedTasksCubit;

  Timer? _timer;

  ActiveTasksCubit(
      {required this.missedTasksCubit, required this.completedTasksCubit})
      : super([]) {
    _startTimerIfNeeded();
  }

  void addTask(Task task) {
    emit([...state, task]);
    _startTimerIfNeeded();
  }

  void editTask(Task updatedTask) {
    final updatedList =
        state.map((t) => t.id == updatedTask.id ? updatedTask : t).toList();
    emit(updatedList);
  }

  void removeTask(Task task) {
    emit(state.where((t) => t.id != task.id).toList());
    _stopTimerIfNeeded();
  }

  void markAsDone(Task task) {
    removeTask(task);
    completedTasksCubit.addTask(task.copyWith(status: TaskStatus.completed));
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

  void _onTick() {
    final now = DateTime.now();
    final List<Task> stillActive = [];
    final List<Task> justMissed = [];

    for (var task in state) {
      if (task.deadline.isBefore(now) && task.status == TaskStatus.active) {
        justMissed.add(task.copyWith(status: TaskStatus.missed));
      } else {
        stillActive.add(task);
      }
    }

    if (justMissed.isNotEmpty) {
      // Remove missed tasks from active and add to missed cubit
      emit(stillActive);
      for (var missed in justMissed) {
        missedTasksCubit.addTask(missed);
      }
    } else {
      // No tasks expired this tick — emit same list to update UI timers
      emit(List.from(state));
    }

    // Stop timer if no active tasks
    _stopTimerIfNeeded();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
