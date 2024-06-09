import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntp/ntp.dart';

import 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(TimerInitial()) {
    _loadUseCases();
  }

  void onCubitStart() {
    getRealTime();
  }

  void _loadUseCases() {}

  static TimerCubit of(BuildContext context) => BlocProvider.of(context);

  void getRealTime() async {
    try {
      emit(TimerLoading());
      final dateTime = await NTP.now();
      emit(TimerLoaded(dateTime));
    } catch (_) {
    }
  }
}
