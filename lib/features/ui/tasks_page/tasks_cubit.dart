import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_injector.dart';
import '../../domain/use_case/get_tasks_use_case.dart';
import 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  late GetTasksUseCase _getTasksUseCase;

  TasksCubit() : super(TasksInitial()) {
    _loadUseCases();
  }

  static TasksCubit of(context) => BlocProvider.of(context);

  void _loadUseCases() {
    _getTasksUseCase = injector();
  }

  void onCubitStart(
      {required int numberOfTasks, required int sequenceOfTasks}) async {
    emit(TasksLoading());
    final tasks = await _getTasksUseCase.execute(
        numberOfTasks: numberOfTasks, tasksSequence: sequenceOfTasks);
    emit(TasksLoaded(tasks));
  }
}
