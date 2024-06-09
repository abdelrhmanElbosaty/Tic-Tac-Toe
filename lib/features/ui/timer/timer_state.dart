import 'package:equatable/equatable.dart';

abstract class TimerState extends Equatable {
  const TimerState();

  @override
  List<Object?> get props => [];
}

class TimerInitial extends TimerState {}

class TimerLoading extends TimerState {}

class TimerError extends TimerState {}

class TimerLoaded extends TimerState {
  final DateTime realTimeTimer;

  const TimerLoaded(this.realTimeTimer);

  @override
  List<Object?> get props => [realTimeTimer];
}
