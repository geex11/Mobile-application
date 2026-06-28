import 'event_logger.dart';

class KeyboardController {
  final EventLogger logger;

  KeyboardController(this.logger);

  void onTextChanged(String text) {
    logger.log('⌨️ Input changed: "$text"');
  }

  void onKeySubmit(String text) {
    if (text.trim().isEmpty) {
      logger.log('⌨️ Enter pressed: (empty input)');
    } else {
      logger.log('⌨️ Form submitted: "$text"');
    }
  }

  void onFocusGained() => logger.log('⌨️ Keyboard focus gained');

  void onFocusLost() => logger.log('⌨️ Keyboard focus lost');
}
