import '../../domain/entities/task_entity.dart';
import '../models/api_tasks_result.dart';

extension ConvertApiCartsResult on ApiTask {
  Task get mapTask {
    return Task(
      id: taskId ?? '',
      title: title ?? '',
      startTime: DateTime.fromMillisecondsSinceEpoch(startTime ?? 0),
      status: TaskFilterEnum.unAssign,
      taskDurationInSeconds: taskDurationInSeconds ?? 0,
      taskStartTime: DateTime.fromMillisecondsSinceEpoch(taskStartTime ?? 0),
    );
  }
}
