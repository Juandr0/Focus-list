import 'package:flutter/material.dart';
import 'package:focus_list/features/tasks/models/task.dart';
import 'package:intl/intl.dart';

Widget? buildCardSubtitle(Task task) {
  final now = DateTime.now();
  final remaining = task.deadline.difference(now);
  final minutes = remaining.inMinutes;
  final seconds = remaining.inSeconds % 60;

  switch (task.status) {
    case TaskStatus.active:
      return Text(
        'Time left: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
      );
    case TaskStatus.missed:
      return Text(
        'Expired at: ${DateFormat('yyyy-MM-dd HH:mm').format(task.deadline)}',
      );
    case TaskStatus.completed:
      return Text(
        'Completed at: ${DateFormat('yyyy-MM-dd HH:mm').format(task.deadline)}',
      );
    default:
      return null;
  }
}
