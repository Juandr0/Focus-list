import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/tasks/cubits/active_tasks_cubit.dart';
import 'features/tasks/cubits/completed_tasks_cubit.dart';
import 'features/tasks/cubits/missed_tasks_cubit.dart';
import 'features/tasks/screens/home_screen.dart';

void main() {
  runApp(const FocusListApp());
}

class FocusListApp extends StatelessWidget {
  const FocusListApp({super.key});

  @override
  Widget build(BuildContext context) {
    final missedCubit = MissedTasksCubit();
    final completedCubit = CompletedTasksCubit();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ActiveTasksCubit>(
          create: (context) => ActiveTasksCubit(
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
