import 'package:tic_tak_toe/features/data/mappers/api_carts_map.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../mocked.dart';

class TasksRepositoryImpl implements TasksRepository {
  @override
  Future<List<Task>> getTasks(
      {required int numberOfTasks, required int tasksSequence}) async {
    final tasks = MockedData.getTasks(
        numberOfTasks: numberOfTasks, tasksSequence: tasksSequence);
    return tasks.map((e) => e.mapTask).toList();
  }
}
