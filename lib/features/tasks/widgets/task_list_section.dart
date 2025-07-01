import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_list/constants/app_sizes.dart';
import 'package:focus_list/features/tasks/models/task.dart';
import 'package:focus_list/features/tasks/utils/build_task_card.dart';

class TaskListSection<T extends Cubit<List<Task>>> extends StatelessWidget {
  final String title;

  const TaskListSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<T>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSizes.verticalSpaceSmall,
        BlocBuilder<T, List<Task>>(
          bloc: cubit,
          builder: (context, tasks) {
            if (tasks.isEmpty) {
              return const Text(
                'No tasks here',
                style: TextStyle(color: Colors.grey),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return buildTaskCard(context, task);
              },
            );
          },
        ),
        AppSizes.verticalSpaceLarge,
      ],
    );
  }
}
