import 'event_logger.dart';

class GestureController {
  final EventLogger logger;

  GestureController(this.logger);

  void onTap() => logger.log('👆 Tap detected');

  void onDoubleTap() => logger.log('👆👆 Double tap detected');

  void onLongPress() => logger.log('📌 Long press — context menu displayed');

  void onSwipeLeft() => logger.log('👈 Swipe Left — Previous Page');

  void onSwipeRight() => logger.log('👉 Swipe Right — Next Page');

  void onSwipeUp() => logger.log('👆 Swipe Up — Scroll to top');

  void onSwipeDown() => logger.log('👇 Swipe Down — Refresh');
}
