import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tak_toe/core/dimensions.dart';

import '../../../core/app_colors.dart';
import '../../../core/text_styles.dart';
import 'tasks_cubit.dart';
import 'widgets/tasks_body.dart';

class TasksPage extends StatelessWidget {
  final int numberOfTasks;
  final int tasksSequence;

  const TasksPage({
    super.key,
    required this.numberOfTasks,
    required this.tasksSequence,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(),
          // child: leading,
        ),
        centerTitle: true,
        title: Text('Tic Tac Toe', style: TextStyles.bold()),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => TasksCubit()
            ..onCubitStart(
              numberOfTasks: numberOfTasks,
              sequenceOfTasks: tasksSequence,
            ),
          child: _TasksPage(numberOfTasks, tasksSequence),
        ),
      ),
    );
  }
}

class _TasksPage extends StatelessWidget {
  final int numberOfTasks;
  final int tasksSequence;

  const _TasksPage(this.numberOfTasks, this.tasksSequence);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingDimensions.large,
        vertical: PaddingDimensions.large,
      ),
      child: SafeArea(
        child: TasksBody(
          tasksSequence: tasksSequence,
          numberOfTasks: numberOfTasks,
        ),
      ),
    );
  }
}
