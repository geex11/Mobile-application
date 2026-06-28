class EventLogger {
  final List<String> _events = [];

  void log(String event) {
    final t = DateTime.now();
    final time =
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')}';
    _events.insert(0, '[$time] $event');
    if (_events.length > 30) _events.removeLast();
  }

  List<String> get events => List.unmodifiable(_events);

  void clear() => _events.clear();
}
