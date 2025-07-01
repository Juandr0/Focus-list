import 'package:flutter/material.dart';
import 'package:focus_list/features/tasks/widgets/task_list_section.dart';
import '../../../constants/app_sizes.dart';
import '../cubits/active_tasks_cubit.dart';
import '../cubits/completed_tasks_cubit.dart';
import '../cubits/missed_tasks_cubit.dart';
import 'task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus List')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskScreen()),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: const [
            TaskListSection<ActiveTasksCubit>(title: 'Active Tasks'),
            TaskListSection<CompletedTasksCubit>(title: 'Completed Tasks'),
            TaskListSection<MissedTasksCubit>(title: 'Missed Tasks'),
          ],
        ),
      ),
    );
  }
}
