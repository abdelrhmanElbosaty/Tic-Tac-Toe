import '../../core/app_injector.dart';
import '../data/repositories_imp/tasks_repository_imp.dart';
import '../domain/repositories/tasks_repository.dart';
import '../domain/use_case/get_tasks_use_case.dart';

class TasksDi {
  TasksDi._();

  static Future<void> initialize() async {
    injector
        .registerLazySingleton<TasksRepository>(() => TasksRepositoryImpl());

    injector.registerFactory(() => GetTasksUseCase(injector()));
  }
}
