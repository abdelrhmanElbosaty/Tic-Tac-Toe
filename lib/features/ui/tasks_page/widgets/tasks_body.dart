import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tak_toe/core/app_colors.dart';
import 'package:tic_tak_toe/core/dimensions.dart';

import '../../../../core/text_styles.dart';
import '../../../domain/entities/task_entity.dart';
import '../tasks_cubit.dart';
import '../tasks_state.dart';
import 'task_filter.dart';
import 'task_item.dart';

class TasksBody extends StatefulWidget {
  final int numberOfTasks;
  final int tasksSequence;

  const TasksBody({
    super.key,
    required this.numberOfTasks,
    required this.tasksSequence,
  });

  @override
  State<TasksBody> createState() => _TasksBodyState();
}

class _TasksBodyState extends State<TasksBody> {
  late ValueNotifier<List<Task>?> unAssignedTasksValueNotifier =
      ValueNotifier(null);
  late ValueNotifier<List<Task>?> completedTasksValueNotifier =
      ValueNotifier(null);
  late ValueNotifier<Task?> assignedTaskValueNotifier = ValueNotifier(null);
  ValueNotifier<TaskFilterEnum> currentTapValueNotifier =
      ValueNotifier(TaskFilterEnum.unAssign);

  List<String> displayXorO = List.generate(9, (index) => '');
  bool oTurn = true;
  bool playIsEnabled = true;

  @override
  void dispose() {
    currentTapValueNotifier.dispose();
    unAssignedTasksValueNotifier.dispose();
    completedTasksValueNotifier.dispose();
    assignedTaskValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksCubit, TasksState>(
      listener: (context, state) {
        if (state is TasksLoaded) {
          unAssignedTasksValueNotifier = ValueNotifier(state.tasks);
        }
      },
      child: BlocBuilder<TasksCubit, TasksState>(
        buildWhen: (previous, current) =>
            previous != current && current is TasksLoaded,
        builder: (context, state) {
          if (state is TasksLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: currentTapValueNotifier,
                    builder: (context, value, child) => Column(
                      children: [
                        TaskFilter(
                          onTap: (filter) {
                            currentTapValueNotifier.value = filter;
                          },
                          currentTap: currentTapValueNotifier.value,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              _buildOffstageNavigator(TaskFilterEnum.unAssign),
                              _buildOffstageNavigator(TaskFilterEnum.assign),
                              _buildOffstageNavigator(TaskFilterEnum.completed),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  final List<TaskFilterEnum> _loadedTabs = [];
  final Map<TaskFilterEnum, GlobalKey<NavigatorState>> _navigatorKeys = {
    TaskFilterEnum.unAssign: GlobalKey<NavigatorState>(),
    TaskFilterEnum.assign: GlobalKey<NavigatorState>(),
    TaskFilterEnum.completed: GlobalKey<NavigatorState>(),
  };

  Widget _buildOffstageNavigator(TaskFilterEnum itemType) {
    if (currentTapValueNotifier.value == itemType) {
      _addCurrentTabAsLoaded();
    }
    return Offstage(
      offstage: currentTapValueNotifier.value != itemType,
      child: _isTabLoaded(itemType) ? _buildNavigator(itemType) : Container(),
    );
  }

  bool _isTabLoaded(TaskFilterEnum itemType) {
    return _loadedTabs.contains(itemType);
  }

  void _addCurrentTabAsLoaded() {
    if (_shouldAddCurrentTabAsLoaded()) {
      _loadedTabs.add(currentTapValueNotifier.value);
    }
  }

  bool _shouldAddCurrentTabAsLoaded() {
    return !_loadedTabs.contains(currentTapValueNotifier.value);
  }

  Widget _buildNavigator(TaskFilterEnum itemType) {
    return Navigator(
      key: _navigatorKeys[itemType],
      initialRoute: '/',
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
            builder: (context) => _routeForItemType(itemType, routeSettings));
      },
    );
  }

  Widget _routeForItemType(
      TaskFilterEnum itemType, RouteSettings routeSettings) {
    switch (itemType) {
      case TaskFilterEnum.unAssign:
        return _taskWidget(itemType, unAssignedTasksValueNotifier);

      case TaskFilterEnum.assign:
        return ValueListenableBuilder(
            valueListenable: assignedTaskValueNotifier,
            builder: (context, value, child) {
              if (value != null) {
                return Column(
                  children: [
                    TaskItem(
                      value,
                      filter: TaskFilterEnum.assign,
                      onTimerEnded: (String? taskId) {
                        _showDialog(
                          title: 'Time is ended, try with another one!',
                          onTap: () {
                            _removeAssignedTaskWhenTimerEnded();
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    if (playIsEnabled) ...[
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyles.medium(),
                            children: [
                              const TextSpan(text: 'Player'),
                              const WidgetSpan(
                                  child:
                                      SizedBox(width: PaddingDimensions.small)),
                              TextSpan(
                                text: oTurn ? "'O'" : "'X'",
                                style: TextStyle(
                                    color: oTurn
                                        ? AppColors.oColor
                                        : AppColors.xColor),
                              ),
                              const WidgetSpan(
                                  child:
                                      SizedBox(width: PaddingDimensions.small)),
                              const TextSpan(text: 'Turn'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: PaddingDimensions.large),
                    ],
                    Expanded(
                      child: GridView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: 9,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _onXOTap(index),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Center(
                                child: Text(
                                  displayXorO[index],
                                  style: TextStyles.medium(
                                    fontSize: 36,
                                    color: displayXorO[index] == 'O'
                                        ? AppColors.oColor
                                        : AppColors.xColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              }
              return Center(
                child: Text(
                  textAlign: TextAlign.center,
                  'Assign task to play Tic Tac Toe',
                  style: TextStyles.medium(fontSize: Dimensions.xxxxLarge),
                ),
              );
            });

      case TaskFilterEnum.completed:
        return _taskWidget(itemType, completedTasksValueNotifier);
    }
  }

  Widget _taskWidget(
      TaskFilterEnum filter, ValueListenable<List<Task>?> valueListenable) {
    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (context, value, child) {
        if ((value?.isEmpty ?? false) && filter == TaskFilterEnum.unAssign) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
                child: TextButton(
              onPressed: () {
                assignedTaskValueNotifier.value = null;
                completedTasksValueNotifier.value = null;
                context.read<TasksCubit>().onCubitStart(
                      sequenceOfTasks: widget.tasksSequence,
                      numberOfTasks: widget.numberOfTasks,
                    );
              },
              child: const Text(
                'Reload Tasks',
                style: TextStyle(fontSize: 20),
              ),
            )),
          );
        }
        if (value?.isNotEmpty ?? false) {
          return ListView.builder(
            itemCount: value?.length,
            itemBuilder: (ctx, index) => InkWell(
              onTap: () {
                // navigateToTaskPage(context, allTask[index]);
              },
              child: TaskItem(
                key: ValueKey(value?.length),
                value![index],
                filter: filter,
                onTimerEnded: (String? taskId) {
                  if (filter == TaskFilterEnum.unAssign) {
                    _removeTask(taskId: taskId);
                  }
                },
                onTap: filter != TaskFilterEnum.unAssign
                    ? null
                    : () {
                        _addAssignedTask(taskId: value[index].id);
                      },
              ),
            ),
          );
        }

        if ((value == null) && filter == TaskFilterEnum.completed) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: PaddingDimensions.large),
            child: Center(
                child: Text(
              'There is no completed tasks',
              style: TextStyles.medium(fontSize: Dimensions.xxxxLarge),
            )),
          );
        }

        return const SizedBox();
      },
    );
  }

  Future<void> _onXOTap(int index) async {
    setState(() {
      if (oTurn && displayXorO[index] == '') {
        displayXorO[index] = 'O';
        oTurn = !oTurn;
      }
      _checkWinner();
    });
    await Future.delayed(const Duration(milliseconds: 500));

    if (!oTurn && playIsEnabled) {
      _makeComputerMove();
    }
  }

  void _makeComputerMove() {
    List<int> emptyBoxes = [];

    setState(() {
      for (int i = 0; i < displayXorO.length; i++) {
        if (displayXorO[i] == '') {
          emptyBoxes.add(i);
        }
      }

      if (emptyBoxes.isNotEmpty) {
        int randomIndex = Random().nextInt(emptyBoxes.length);
        int computerMoveIndex = emptyBoxes[randomIndex];
        displayXorO[computerMoveIndex] = 'X';
        oTurn = !oTurn;
        _checkWinner();
      }
    });
  }

  void _checkWinner() {
    //Rows
    if (displayXorO[0] != '' &&
        displayXorO[0] == displayXorO[1] &&
        displayXorO[0] == displayXorO[2]) {
      _showWinningDialog(winner: displayXorO[0]);
    }

    if (displayXorO[3] != '' &&
        displayXorO[3] == displayXorO[4] &&
        displayXorO[3] == displayXorO[5]) {
      _showWinningDialog(winner: displayXorO[3]);
    }

    if (displayXorO[6] != '' &&
        displayXorO[6] == displayXorO[7] &&
        displayXorO[6] == displayXorO[8]) {
      _showWinningDialog(winner: displayXorO[6]);
    }

    //Columns
    if (displayXorO[0] != '' &&
        displayXorO[0] == displayXorO[3] &&
        displayXorO[0] == displayXorO[6]) {
      _showWinningDialog(winner: displayXorO[0]);
    }

    if (displayXorO[1] != '' &&
        displayXorO[1] == displayXorO[4] &&
        displayXorO[1] == displayXorO[7]) {
      _showWinningDialog(winner: displayXorO[1]);
    }

    if (displayXorO[2] != '' &&
        displayXorO[2] == displayXorO[5] &&
        displayXorO[2] == displayXorO[8]) {
      _showWinningDialog(winner: displayXorO[2]);
    }

    //Diagonals
    if (displayXorO[0] != '' &&
        displayXorO[0] == displayXorO[4] &&
        displayXorO[0] == displayXorO[8]) {
      _showWinningDialog(winner: displayXorO[0]);
    }

    if (displayXorO[2] != '' &&
        displayXorO[2] == displayXorO[4] &&
        displayXorO[2] == displayXorO[6]) {
      _showWinningDialog(winner: displayXorO[2]);
    }

    if (_isBoardFull(displayXorO) && playIsEnabled) {
      setState(() {
        playIsEnabled = false;
      });
      _showDialog(title: 'Reload!', onTap: _clearBoard);
    }
  }

  void _clearBoard() {
    setState(() {
      oTurn = true;
      playIsEnabled = true;
      displayXorO = List.generate(9, (index) => '');
    });
  }

  bool _isBoardFull(List<String> board) {
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        return false;
      }
    }
    return true;
  }

  void _showWinningDialog({required String winner}) {
    setState(() {
      playIsEnabled = false;
    });

    if (!playIsEnabled) {
      _showDialog(
        title: 'Winner is Player $winner',
        onTap: () {
          if (winner == 'O') {
            _addTaskToCompleteSection();
            _removeAssignedTaskWhenTimerEnded();
          } else {
            _clearBoard();
          }
        },
      );
    }
  }

  void _showDialog({required String title, void Function()? onTap}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: TextStyles.medium(), textAlign: TextAlign.center),
            const SizedBox(height: PaddingDimensions.large),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                if (onTap != null) onTap();
              },
              textColor: AppColors.white,
              color: AppColors.primaryColor,
              child: Text('Ok',
                  style: TextStyles.bold(
                      color: AppColors.white, fontSize: Dimensions.xxLarge)),
            ),
          ],
        )),
      ),
    );
  }

  int? _unAssignedTaskEndDuration;

  void _removeTask({String? taskId}) {
    if (unAssignedTasksValueNotifier.value?.isNotEmpty ?? false) {
      List<Task> newList = unAssignedTasksValueNotifier.value ?? [];
      newList.removeWhere((element) => element.id == taskId);

      unAssignedTasksValueNotifier.value = [
        ...newList.map((e) {
          _unAssignedTaskEndDuration ??=
              DateTime.now().difference(e.startTime).inSeconds;
          return e.modify(
              taskDurationInSeconds: (e.taskDurationInSeconds -
                  (_unAssignedTaskEndDuration ?? 0)));
        })
      ];
    }
  }

  void _addAssignedTask({String? taskId}) {
    if (assignedTaskValueNotifier.value == null) {
      _clearBoard();

      int? assignedDateDifference;
      Task assignedTask = unAssignedTasksValueNotifier.value!
          .firstWhere((element) => element.id == taskId);

      assignedDateDifference ??=
          DateTime.now().difference(assignedTask.startTime).inSeconds;
      assignedTask = assignedTask.modify(
          taskDurationInSeconds:
              assignedTask.taskDurationInSeconds - (assignedDateDifference));

      assignedTaskValueNotifier.value = assignedTask;
      currentTapValueNotifier.value = TaskFilterEnum.assign;
      _removeTask(taskId: taskId);

      assignedDateDifference = null;
    } else {
      _showDialog(
        title: 'You have an assigned task',
        onTap: () {},
      );
    }
  }

  void _removeAssignedTaskWhenTimerEnded() {
    assignedTaskValueNotifier.value = null;
  }

  void _addTaskToCompleteSection() {
    Task assignedTask = assignedTaskValueNotifier.value!;
    List<Task> completedList = completedTasksValueNotifier.value ?? [];
    completedList.add(assignedTask);
    completedTasksValueNotifier.value = [...completedList];
    currentTapValueNotifier.value = TaskFilterEnum.completed;
  }
}
