import 'models/api_tasks_result.dart';
import 'package:uuid/uuid.dart';

class MockedData {
  static List<ApiTask> getTasks({required int numberOfTasks, required int tasksSequence}) {
    return List.generate(numberOfTasks, (index) {
      final taskDurationInSeconds = ((index + 1) * tasksSequence) * 60;
      return ApiTask(
        taskId: const Uuid().v4(),
        title: 'Task${index + 1}',
        startTime: DateTime.now().millisecondsSinceEpoch,
        taskDurationInSeconds: taskDurationInSeconds,
        taskStartTime: DateTime.now()
            .add(Duration(seconds: taskDurationInSeconds))
            .millisecondsSinceEpoch,
      );
    });
  }
}
