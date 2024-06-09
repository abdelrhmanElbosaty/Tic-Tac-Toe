import '../entities/task_entity.dart';

abstract class TasksRepository {
  Future<List<Task>> getTasks({required int numberOfTasks,required int tasksSequence});
}
