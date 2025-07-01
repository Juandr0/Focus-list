import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_list/constants/app_config.dart';
import 'package:focus_list/features/tasks/cubits/missed_tasks_cubit.dart';
import '../../../constants/app_sizes.dart';
import '../cubits/active_tasks_cubit.dart';
import '../models/task.dart';

class TaskScreen extends StatefulWidget {
  final Task? existingTask;

  const TaskScreen({super.key, this.existingTask});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;

  int _minutes = AppConfig.taskDefaultMinutes;

  @override
  void initState() {
    super.initState();
    final task = widget.existingTask;
    _titleController = TextEditingController(text: task?.title ?? '');

    if (task != null) {
      final duration = task.deadline.difference(task.createdAt);
      _minutes = duration.inMinutes
          .clamp(AppConfig.taskMinMinutes, AppConfig.taskMaxMinutes);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final isEditing = widget.existingTask != null;
      final isRescheduling = widget.existingTask?.status == TaskStatus.missed;

      final createdAt = DateTime.now();
      final id = isEditing
          ? widget.existingTask!.id
          : DateTime.now().millisecondsSinceEpoch.toString();

      final newTask = Task(
        id: id,
        title: _titleController.text.trim(),
        createdAt: createdAt,
        deadline: createdAt.add(Duration(minutes: _minutes)),
        status: TaskStatus.active,
      );

      final activeCubit = context.read<ActiveTasksCubit>();

      if (isRescheduling) {
        context.read<MissedTasksCubit>().removeTask(widget.existingTask!);
        activeCubit.addTask(newTask);
      } else if (isEditing) {
        activeCubit.editTask(newTask);
      } else {
        activeCubit.addTask(newTask);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingTask != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Task' : 'Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Please enter a task title'
                    : null,
              ),
              AppSizes.verticalSpaceLarge,
              Text('Time limit (minutes): $_minutes'),
              Slider(
                min: AppConfig.taskMinMinutes.toDouble(),
                max: AppConfig.taskMaxMinutes.toDouble(),
                divisions: AppConfig.taskMaxMinutes,
                value: _minutes.toDouble(),
                label: _minutes.toString(),
                onChanged: (value) => setState(() => _minutes = value.toInt()),
              ),
              AppSizes.verticalSpaceLarge,
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEditing ? 'Save' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
