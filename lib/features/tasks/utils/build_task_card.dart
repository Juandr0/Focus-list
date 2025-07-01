import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task.dart';
import '../screens/task_screen.dart';
import '../cubits/active_tasks_cubit.dart';
import '../widgets/task_card.dart';

TaskCard buildTaskCard(BuildContext context, Task task) {
  return TaskCard(
    task: task,
    onMarkDone: task.status == TaskStatus.active
        ? () => context.read<ActiveTasksCubit>().markAsDone(task)
        : null,
    onEdit: task.status == TaskStatus.missed
        ? () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TaskScreen(existingTask: task),
              ),
            )
        : null,
  );
}
