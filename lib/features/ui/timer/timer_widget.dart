import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'dispose_timer_subscription.dart';
import 'timer_cubit.dart';
import 'timer_state.dart';

class TimerWidget extends StatelessWidget {
  final DateTime createdAt;
  final int durationInSec;

  final TextStyle? timerTextStyle;
  final VoidCallback onTimerEnded;

  const TimerWidget({
    super.key,
    required this.createdAt,
    required this.durationInSec,
    this.timerTextStyle,
    required this.onTimerEnded,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerCubit()..onCubitStart(),
      child: TimerWidgetBody(
        createdAt: createdAt,
        durationInSec: durationInSec,
        onTimerEnded: onTimerEnded,
        timerTextStyle: timerTextStyle,
      ),
    );
  }
}

class TimerWidgetBody extends StatefulWidget {
  final DateTime createdAt;
  final int durationInSec;
  final TextStyle? timerTextStyle;
  final VoidCallback onTimerEnded;

  const TimerWidgetBody({
    super.key,
    required this.createdAt,
    required this.durationInSec,
    this.timerTextStyle,
    required this.onTimerEnded,
  });

  @override
  State<TimerWidgetBody> createState() => _TimerWidgetBodyState();
}

class _TimerWidgetBodyState extends State<TimerWidgetBody>
    with WidgetsBindingObserver {
  final _composite = CompositeSubscription();

  Timer? _requestTimer;
  Duration _requestDuration = Duration.zero;
  AppLifecycleState? appState;

  void _disposeTimerSubscription() {
    _composite.add(DisposeTimerSubscription.stream().listen((event) {
      _disposeTimer();
    }));
  }

  @override
  void initState() {
    _disposeTimerSubscription();
    context.read<TimerCubit>().getRealTime();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _disposeTimer();
    }
    if (state == AppLifecycleState.resumed) {
      if (appState == AppLifecycleState.paused) {
        if (mounted) {
          context.read<TimerCubit>().getRealTime();
        }
      }
      appState = state;
    }
    if (appState != AppLifecycleState.paused) {
      appState = state;
    }
  }

  void _disposeTimer() {
    _requestDuration = Duration.zero;
    _requestTimer?.cancel();
  }

  @override
  void dispose() {
    _composite.dispose();
    super.dispose();
  }

  void _setRequestDuration(DateTime time) {
    DateTime endDate =
        widget.createdAt.add(Duration(seconds: widget.durationInSec));

    final remainingDuration = endDate.difference((time)).inSeconds;

    if (remainingDuration > widget.durationInSec) {
      _requestDuration = Duration(seconds: widget.durationInSec);
    } else if (remainingDuration.isNegative) {
      _disposeTimer();
    } else {
      _requestDuration = Duration(seconds: remainingDuration);
    }
  }

  void _startRequestTimer(DateTime time) {
    const oneSec = Duration(seconds: 1);
    _requestTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (mounted) {
          setState(() {
            if (_requestDuration.inSeconds == 0) {
              timer.cancel();
              widget.onTimerEnded();
            } else {
              _requestDuration = _requestDuration - const Duration(seconds: 1);
            }
          });
        }
      },
    );
  }

  void _handleTimer(TimerLoaded state) {
    _disposeTimer();

    _setRequestDuration(state.realTimeTimer);
    _startRequestTimer(state.realTimeTimer);
  }

  String transformSeconds(int seconds) {
    int days = seconds ~/ (24 * 3600);
    seconds %= (24 * 3600);
    int hours = seconds ~/ 3600;
    seconds %= 3600;
    int minutes = seconds ~/ 60;
    seconds %= 60;

    String daysStr = days.toString();
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return days > 0
        ? "$daysStr:$hoursStr:$minutesStr:$secondsStr"
        : hours > 0
            ? "$hoursStr:$minutesStr:$secondsStr"
            : "$minutesStr:$secondsStr";
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimerCubit, TimerState>(
      listenWhen: (previous, current) {
        if (current is TimerLoaded && previous is TimerLoaded) {
          return previous.realTimeTimer != current.realTimeTimer;
        }
        return false;
      },
      listener: (context, state) {
        if (state is TimerLoaded) {
          _handleTimer(state);
        }
      },
      builder: (context, state) {
        if (state is TimerLoaded) {
          return Text(
            transformSeconds(_requestDuration.inSeconds),
            style:
                widget.timerTextStyle ?? const TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          );
        }

        return Text(
          '--:--',
          style: widget.timerTextStyle ?? const TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
