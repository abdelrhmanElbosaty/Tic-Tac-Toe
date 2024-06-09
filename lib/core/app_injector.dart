import 'package:get_it/get_it.dart';

import '../features/di/tasks_di.dart';

final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  injector.pushNewScope();
  await _registerAppDependencies();
}

Future<void> _registerAppDependencies() async {
  TasksDi.initialize();
}
