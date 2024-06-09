class Task {
  final String id;
  final String title;
  final int taskDurationInSeconds;
  final DateTime startTime;
  final DateTime taskStartTime;
  final TaskFilterEnum status;

  Task({
    required this.id,
    required this.title,
    required this.startTime,
    required this.taskDurationInSeconds,
    required this.taskStartTime,
    required this.status,
  });

  Task modify(
      {TaskFilterEnum? status,
      DateTime? taskStartTime,
      int? taskDurationInSeconds}) {
    return Task(
      id: id,
      startTime: startTime,
      taskStartTime: taskStartTime ?? this.taskStartTime,
      taskDurationInSeconds: taskDurationInSeconds ?? this.taskDurationInSeconds,
      title: title,
      status: status ?? this.status,
    );
  }
}

enum TaskFilterEnum {
  unAssign,
  assign,
  completed;

  String get name {
    switch (this) {
      case TaskFilterEnum.unAssign:
        return 'UnAssign';
      case TaskFilterEnum.assign:
        return 'Assign';
      case TaskFilterEnum.completed:
        return 'Completed';
    }
  }
}
