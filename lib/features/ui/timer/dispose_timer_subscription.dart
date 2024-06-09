import 'package:rxdart/rxdart.dart';

class DisposeTimerSubscription {
  DisposeTimerSubscription._();

  static final _subject = PublishSubject();

  static void pushUpdate() {
    _subject.add(null);
  }

  static Stream<void> stream() {
    return _subject.stream;
  }
}