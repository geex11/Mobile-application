import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/note.dart';
import '../models/timetable_entry.dart';
import '../storage/local_storage.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  bool _isLoading = true;

  String _name = '';
  String _email = '';
  String _regNumber = '';

  int _notesCount = 0;
  int _timetableCount = 0;
  List<Note> _recentNotes = [];
  Map<String, int> _timetableByDay = {};

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    setState(() => _isLoading = true);
    final student = await LocalStorage.getStudent();
    final notesCount = await DatabaseHelper.getNotesCount();
    final timetableCount = await DatabaseHelper.getTimetableCount();
    final recentNotes = await DatabaseHelper.getRecentNotes(3);
    final byDay = await DatabaseHelper.getTimetableCountByDay();

    if (!mounted) return;
    setState(() {
      _name = student['name'] ?? 'Student';
      _email = student['email'] ?? '-';
      _regNumber = student['regNumber'] ?? '-';
      _notesCount = notesCount;
      _timetableCount = timetableCount;
      _recentNotes = recentNotes;
      _timetableByDay = byDay;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBBDEFB),
      appBar: AppBar(
        title: const Text('Reports',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadReport,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1565C0)),
            )
          : RefreshIndicator(
              onRefresh: _loadReport,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader(Icons.person_outline, 'Student Profile'),
                    const SizedBox(height: 10),
                    _card(
                      child: Column(
                        children: [
                          _infoRow(Icons.badge, 'Name', _name),
                          const Divider(height: 20),
                          _infoRow(Icons.email_outlined, 'Email', _email),
                          const Divider(height: 20),
                          _infoRow(Icons.numbers, 'Reg Number', _regNumber),
                          const Divider(height: 20),
                          _infoRow(Icons.school_outlined, 'Course',
                              'BIT4107 Mobile App Development'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    _sectionHeader(Icons.bar_chart, 'Summary Statistics'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            icon: Icons.notes,
                            label: 'Notes',
                            value: '$_notesCount',
                            color: const Color(0xFF1565C0),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _statCard(
                            icon: Icons.calendar_month,
                            label: 'Classes',
                            value: '$_timetableCount',
                            color: const Color(0xFF0D47A1),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _sectionHeader(Icons.notes_outlined, 'Recent Notes'),
                    const SizedBox(height: 10),
                    _recentNotes.isEmpty
                        ? _emptyCard('No notes saved yet.')
                        : _card(
                            child: Column(
                              children: [
                                for (int i = 0; i < _recentNotes.length; i++) ...[
                                  if (i > 0) const Divider(height: 16),
                                  _noteRow(_recentNotes[i]),
                                ],
                              ],
                            ),
                          ),

                    const SizedBox(height: 24),
                    _sectionHeader(Icons.calendar_view_week, 'Timetable by Day'),
                    const SizedBox(height: 10),
                    _timetableByDay.isEmpty
                        ? _emptyCard('No timetable entries yet.')
                        : _card(
                            child: Column(
                              children: [
                                for (int i = 0;
                                    i < TimetableEntry.days.length;
                                    i++) ...[
                                  if (i > 0) const Divider(height: 16),
                                  _dayRow(TimetableEntry.days[i]),
                                ],
                              ],
                            ),
                          ),

                    const SizedBox(height: 24),
                    _sectionHeader(Icons.integration_instructions, 'System Info'),
                    const SizedBox(height: 10),
                    _card(
                      child: Column(
                        children: [
                          _infoRow(Icons.storage, 'Local Storage',
                              'SharedPreferences + SQLite'),
                          const Divider(height: 20),
                          _infoRow(Icons.cloud_outlined, 'API',
                              'DEV.to Public REST API'),
                          const Divider(height: 20),
                          _infoRow(Icons.link, 'Endpoint',
                              '/api/articles?per_page=30&tag=mobile'),
                          const Divider(height: 20),
                          _infoRow(Icons.security, 'Auth', 'None required'),
                          const Divider(height: 20),
                          _infoRow(Icons.error_outline, 'Error Handling',
                              'SocketException, HttpException,\nFormatException, non-200 codes'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0D47A1), size: 20),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1))),
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.blue.shade100,
              blurRadius: 6,
              offset: const Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }

  Widget _emptyCard(String message) {
    return _card(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(message,
              style: const TextStyle(color: Colors.blueGrey, fontSize: 14)),
        ),
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.blue.shade200,
              blurRadius: 6,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1565C0)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF102A43))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _noteRow(Note note) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.sticky_note_2_outlined,
            size: 18, color: Color(0xFF1565C0)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(note.title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF102A43))),
              const SizedBox(height: 2),
              Text(note.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(fontSize: 12, color: Colors.blueGrey)),
              const SizedBox(height: 2),
              Text(note.createdAt,
                  style: const TextStyle(
                      fontSize: 10,
                      color: Colors.blueGrey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dayRow(String day) {
    final count = _timetableByDay[day] ?? 0;
    return Row(
      children: [
        const Icon(Icons.today_outlined, size: 18, color: Color(0xFF1565C0)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(day,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF102A43))),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: count > 0
                ? const Color(0xFFE3F2FD)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            count > 0 ? '$count class${count == 1 ? '' : 'es'}' : 'No classes',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color:
                  count > 0 ? const Color(0xFF1565C0) : Colors.blueGrey,
            ),
          ),
        ),
      ],
    );
  }
}
