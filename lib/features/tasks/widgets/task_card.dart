import 'package:flutter/material.dart';
import 'package:focus_list/constants/app_sizes.dart';
import 'package:focus_list/extensions/task_status_color.dart';
import 'package:focus_list/features/tasks/widgets/build_card_subtitle.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onMarkDone;
  final VoidCallback? onEdit;

  const TaskCard({super.key, required this.task, this.onMarkDone, this.onEdit});

  @override
  Widget build(BuildContext context) {
    Color statusColor = task.status.color;

    return Card(
      color: statusColor,
      margin: const EdgeInsets.symmetric(vertical: AppSizes.marginSmall / 2),
      child: ListTile(
        title: Text(task.title),
        subtitle: buildCardSubtitle(task),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onMarkDone != null)
              ElevatedButton(
                onPressed: onMarkDone,
                child: const Text('Mark as Done'),
              ),
            if (onEdit != null)
              ElevatedButton(
                onPressed: onEdit,
                child: const Text('Edit task'),
              ),
          ],
        ),
      ),
    );
  }
}
