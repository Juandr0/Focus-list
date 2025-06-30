import 'package:flutter/material.dart';
import 'package:focus_list/features/tasks/models/task.dart';

extension TaskStatusColor on TaskStatus {
  Color get color {
    switch (this) {
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.active:
        return Colors.grey;
      case TaskStatus.missed:
        return Colors.red;
      case TaskStatus.paused:
        return Colors.white;
    }
  }
}
