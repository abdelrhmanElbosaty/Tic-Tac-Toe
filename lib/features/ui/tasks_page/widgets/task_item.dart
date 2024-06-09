import 'package:flutter/material.dart';

import '../../../domain/entities/task_entity.dart';
import '../../timer/timer_widget.dart';

class TaskItem extends StatefulWidget {
  const TaskItem(
    this.task, {
    super.key,
    this.onTimerEnded,
    required this.filter,
    this.onTap,
  });

  final void Function()? onTap;
  final TaskFilterEnum filter;
  final Task task;
  final void Function(String? taskId)? onTimerEnded;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.task.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.filter != TaskFilterEnum.completed) ...[
                    const Spacer(),
                    TimerWidget(
                      createdAt: widget.task.taskStartTime,
                      durationInSec: widget.task.taskDurationInSeconds,
                      onTimerEnded: () {
                        if (widget.onTimerEnded != null) {
                          widget.onTimerEnded!(widget.task.id);
                        }
                      },
                    )
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
