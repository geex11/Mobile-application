class TimetableEntry {
  final int? id;
  final String day;
  final String unitCode;
  final String unitName;
  final String startTime;
  final String endTime;
  final String room;
  final String lecturer;

  TimetableEntry({
    this.id,
    required this.day,
    required this.unitCode,
    required this.unitName,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.lecturer,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'day': day,
        'unitCode': unitCode,
        'unitName': unitName,
        'startTime': startTime,
        'endTime': endTime,
        'room': room,
        'lecturer': lecturer,
      };

  factory TimetableEntry.fromMap(Map<String, dynamic> m) => TimetableEntry(
        id: m['id'] as int,
        day: m['day'] as String,
        unitCode: m['unitCode'] as String,
        unitName: m['unitName'] as String,
        startTime: m['startTime'] as String,
        endTime: m['endTime'] as String,
        room: m['room'] as String,
        lecturer: m['lecturer'] as String,
      );

  static const List<String> days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday',
  ];
}
