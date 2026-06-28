import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/timetable_entry.dart';
import 'add_edit_timetable_page.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  List<TimetableEntry> _entries = [];
  List<TimetableEntry> _filtered = [];
  final _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final entries = await DatabaseHelper.getAllTimetableEntries();
    setState(() {
      _entries = entries;
      _filtered = entries;
      _isLoading = false;
    });
  }

  void _onSearch() async {
    final q = _searchController.text.trim();
    if (q.isEmpty) {
      setState(() => _filtered = _entries);
    } else {
      final results = await DatabaseHelper.searchTimetable(q);
      setState(() => _filtered = results);
    }
  }

  void _openAdd() async {
    final added = await Navigator.push<bool>(
        context, MaterialPageRoute(builder: (_) => const AddEditTimetablePage()));
    if (added == true) _load();
  }

  void _openEdit(TimetableEntry entry) async {
    final edited = await Navigator.push<bool>(
        context, MaterialPageRoute(builder: (_) => AddEditTimetablePage(entry: entry)));
    if (edited == true) _load();
  }

  void _delete(TimetableEntry entry) {
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Class', style: TextStyle(color: Color(0xFF0D47A1))),
        content: Text('Delete ${entry.unitCode} on ${entry.day}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await DatabaseHelper.deleteTimetableEntry(entry.id!);
              _load();
              messenger.showSnackBar(const SnackBar(
                content: Text('Class deleted'),
                backgroundColor: Colors.red,
              ));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Group entries by day
  Map<String, List<TimetableEntry>> get _grouped {
    final map = <String, List<TimetableEntry>>{};
    for (final day in TimetableEntry.days) {
      final dayEntries = _filtered.where((e) => e.day == day).toList();
      if (dayEntries.isNotEmpty) map[day] = dayEntries;
    }
    return map;
  }

  static const List<Color> _dayColors = [
    Color(0xFF1565C0),
    Color(0xFF6A1B9A),
    Color(0xFF00695C),
    Color(0xFFE65100),
    Color(0xFFC62828),
  ];

  Color _colorForDay(String day) {
    final idx = TimetableEntry.days.indexOf(day);
    return idx >= 0 ? _dayColors[idx % _dayColors.length] : const Color(0xFF1565C0);
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _grouped;

    return Scaffold(
      backgroundColor: const Color(0xFFBBDEFB),
      appBar: AppBar(
        title: const Text('My Timetable',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text('${_filtered.length} class${_filtered.length == 1 ? '' : 'es'}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAdd,
        backgroundColor: const Color(0xFF1565C0),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Class', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by day, unit, or lecturer...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1565C0)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.blueGrey),
                        onPressed: () { _searchController.clear(); _onSearch(); },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF1565C0)))
                : grouped.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_month, size: 64, color: Colors.blue.shade200),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isNotEmpty
                                  ? 'No classes found'
                                  : 'No classes yet\nTap + to add one',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                        children: grouped.entries.map((entry) {
                          final dayColor = _colorForDay(entry.key);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8, bottom: 8),
                                child: Row(children: [
                                  Container(
                                    width: 4, height: 20,
                                    decoration: BoxDecoration(
                                      color: dayColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(entry.key,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: dayColor)),
                                ]),
                              ),
                              ...entry.value.map((e) => _entryCard(e, dayColor)),
                            ],
                          );
                        }).toList(),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _entryCard(TimetableEntry entry, Color dayColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.blue.shade100, blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 4,
          height: 50,
          decoration: BoxDecoration(color: dayColor, borderRadius: BorderRadius.circular(2)),
        ),
        title: Row(children: [
          Text(entry.unitCode,
              style: TextStyle(fontWeight: FontWeight.bold, color: dayColor)),
          const SizedBox(width: 8),
          Text('${entry.startTime} – ${entry.endTime}',
              style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
        ]),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.unitName, style: const TextStyle(fontSize: 13, color: Color(0xFF0D47A1))),
            const SizedBox(height: 2),
            Row(children: [
              const Icon(Icons.room, size: 13, color: Colors.blueGrey),
              const SizedBox(width: 4),
              Text(entry.room, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
              const SizedBox(width: 12),
              const Icon(Icons.person, size: 13, color: Colors.blueGrey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(entry.lecturer,
                    style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                    overflow: TextOverflow.ellipsis),
              ),
            ]),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.blueGrey),
          onSelected: (v) {
            if (v == 'edit') _openEdit(entry);
            if (v == 'delete') _delete(entry);
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit',
                child: Row(children: [Icon(Icons.edit, color: Color(0xFF1565C0), size: 18), SizedBox(width: 8), Text('Edit')])),
            const PopupMenuItem(value: 'delete',
                child: Row(children: [Icon(Icons.delete, color: Colors.red, size: 18), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))])),
          ],
        ),
      ),
    );
  }
}
