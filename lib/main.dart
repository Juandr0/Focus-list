import 'package:flutter/material.dart';
import 'package:focus_list/features/tasks/models/task.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/tasks/cubits/active_tasks_cubit.dart';
import 'features/tasks/cubits/completed_tasks_cubit.dart';
import 'features/tasks/cubits/missed_tasks_cubit.dart';
import 'features/tasks/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FocusListApp());
}

class FocusListApp extends StatefulWidget {
  const FocusListApp({super.key});

  @override
  State<FocusListApp> createState() => _FocusListAppState();
}

class _FocusListAppState extends State<FocusListApp> {
  bool _isHiveInitialized = false;

  late Box<Task> activeBox;
  late Box<Task> completedBox;
  late Box<Task> missedBox;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TaskStatusAdapter());

    activeBox = await Hive.openBox<Task>('activeTasks');
    completedBox = await Hive.openBox<Task>('completedTasks');
    missedBox = await Hive.openBox<Task>('missedTasks');

    await Hive.openBox<Task>('tasksBox');

    setState(() {
      _isHiveInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isHiveInitialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final completedCubit = CompletedTasksCubit(completedBox);
    final missedCubit = MissedTasksCubit(missedBox);

    return MultiBlocProvider(
      providers: [
        BlocProvider<ActiveTasksCubit>(
          create: (context) => ActiveTasksCubit(
            box: activeBox,
            missedTasksCubit: missedCubit,
            completedTasksCubit: completedCubit,
          ),
        ),
        BlocProvider<CompletedTasksCubit>(
          create: (_) => completedCubit,
        ),
        BlocProvider<MissedTasksCubit>(
          create: (_) => missedCubit,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Focus List',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
