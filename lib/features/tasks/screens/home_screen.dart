import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_sizes.dart';
import '../cubits/active_tasks_cubit.dart';
import '../cubits/completed_tasks_cubit.dart';
import '../cubits/missed_tasks_cubit.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
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
            Section<ActiveTasksCubit>(title: 'Active Tasks'),
            Section<CompletedTasksCubit>(title: 'Completed Tasks'),
            Section<MissedTasksCubit>(title: 'Missed Tasks'),
          ],
        ),
      ),
    );
  }
}

class Section<T extends Cubit<List<Task>>> extends StatelessWidget {
  final String title;

  const Section({super.key, required this.title});

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
                return TaskCard(
                  task: task,
                  onMarkDone: T == ActiveTasksCubit
                      ? () {
                          (cubit as ActiveTasksCubit).markAsDone(task);
                        }
                      : null,
                );
              },
            );
          },
        ),
        AppSizes.verticalSpaceLarge,
      ],
    );
  }
}
