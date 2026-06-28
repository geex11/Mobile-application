class Attendance {
  final int? id;
  final String studentName;
  final String regNumber;
  final String unitName;
  final String date;
  final String status; // Present, Absent, Late

  static const List<String> statuses = ['Present', 'Absent', 'Late'];

  Attendance({
    this.id,
    required this.studentName,
    required this.regNumber,
    required this.unitName,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'studentName': studentName,
        'regNumber': regNumber,
        'unitName': unitName,
        'date': date,
        'status': status,
      };

  factory Attendance.fromMap(Map<String, dynamic> map) => Attendance(
        id: map['id'] as int?,
        studentName: map['studentName'] as String,
        regNumber: map['regNumber'] as String,
        unitName: map['unitName'] as String,
        date: map['date'] as String,
        status: map['status'] as String,
      );
}
