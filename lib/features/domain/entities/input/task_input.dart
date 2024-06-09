import 'package:equatable/equatable.dart';

import '../task_entity.dart';

class TaskInput extends Equatable {
  final String? documentId;
  final String? title;
  final String? description;
  final TaskFilterEnum? status;

  const TaskInput({
    this.documentId,
    this.title,
    this.description,
    this.status,
  });

  @override
  List<Object?> get props => [
        documentId,
        title,
        description,
        status,
      ];
}
