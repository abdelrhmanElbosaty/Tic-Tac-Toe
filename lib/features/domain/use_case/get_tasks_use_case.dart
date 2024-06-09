import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class GetTasksUseCase {
  final TasksRepository repository;

  GetTasksUseCase(this.repository);

  Future<List<Task>> execute({required int numberOfTasks, required int tasksSequence}) async {
    return repository.getTasks(numberOfTasks: numberOfTasks,tasksSequence: tasksSequence);
  }
}
