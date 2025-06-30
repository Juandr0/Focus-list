import 'package:flutter/material.dart';
import 'package:focus_list/constants/app_sizes.dart';
import 'package:focus_list/extensions/task_status_color.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onMarkDone;

  const TaskCard({super.key, required this.task, this.onMarkDone});

  @override
  Widget build(BuildContext context) {
    final remaining = task.deadline.difference(DateTime.now());
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;

    final isMissed = task.status == TaskStatus.missed;
    Color statusColor = task.status.color;

    return Card(
      color: statusColor,
      margin: const EdgeInsets.symmetric(vertical: AppSizes.marginSmall / 2),
      child: ListTile(
        title: Text(task.title),
        subtitle: isMissed
            ? null
            : Text(
                'Time left: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'),
        trailing: onMarkDone == null
            ? null
            : ElevatedButton(
                onPressed: onMarkDone,
                child: const Text('Mark as Done'),
              ),
      ),
    );
  }
}
