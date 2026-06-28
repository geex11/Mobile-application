import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/attendance.dart';
import 'add_attendance_page.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<Attendance> _records = [];
  Map<String, int> _summary = {};
  bool _isLoading = true;
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final records = await DatabaseHelper.getAllAttendance();
    final summary = await DatabaseHelper.getAttendanceSummary();
    if (!mounted) return;
    setState(() {
      _records = records;
      _summary = summary;
      _isLoading = false;
    });
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      await _load();
      return;
    }
    final records = await DatabaseHelper.searchAttendance(query.trim());
    if (!mounted) return;
    setState(() => _records = records);
  }

  Future<void> _delete(Attendance record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Record'),
        content: Text(
            'Delete attendance record for ${record.unitName} on ${record.date}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child:
                  const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed == true && record.id != null) {
      await DatabaseHelper.deleteAttendance(record.id!);
      await _load();
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Present':
        return Colors.green;
      case 'Absent':
        return Colors.red;
      case 'Late':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBBDEFB),
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  hintText: 'Search by unit, date, status...',
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                ),
                onChanged: _search,
              )
            : const Text('Attendance',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search,
                color: Colors.white),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _load();
                }
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1565C0)))
          : RefreshIndicator(
              onRefresh: _load,
              child: Column(
                children: [
                  // Summary bar
                  Container(
                    color: const Color(0xFF1565C0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _summaryChip('Present',
                            _summary['Present'] ?? 0, Colors.green),
                        _summaryChip(
                            'Absent', _summary['Absent'] ?? 0, Colors.red),
                        _summaryChip(
                            'Late', _summary['Late'] ?? 0, Colors.orange),
                        _summaryChip(
                            'Total',
                            (_summary['Present'] ?? 0) +
                                (_summary['Absent'] ?? 0) +
                                (_summary['Late'] ?? 0),
                            Colors.white),
                      ],
                    ),
                  ),

                  Expanded(
                    child: _records.isEmpty
                        ? ListView(
                            children: const [
                              SizedBox(height: 80),
                              Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.how_to_reg_outlined,
                                        size: 64, color: Colors.blueGrey),
                                    SizedBox(height: 16),
                                    Text('No attendance records yet.',
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 15)),
                                    SizedBox(height: 8),
                                    Text(
                                        'Tap + to record your first attendance.',
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 13)),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _records.length,
                            itemBuilder: (ctx, i) =>
                                _buildCard(_records[i]),
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        tooltip: 'Record Attendance',
        onPressed: () async {
          final added = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
                builder: (_) => const AddAttendancePage()),
          );
          if (added == true) await _load();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _summaryChip(String label, int count, Color color) {
    return Column(
      children: [
        Text('$count',
            style: TextStyle(
                color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildCard(Attendance record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: _statusColor(record.status).withOpacity(0.15),
          child: Icon(
            record.status == 'Present'
                ? Icons.check_circle
                : record.status == 'Late'
                    ? Icons.access_time
                    : Icons.cancel,
            color: _statusColor(record.status),
          ),
        ),
        title: Text(record.unitName,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF0D47A1))),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(record.date,
                style:
                    const TextStyle(fontSize: 12, color: Colors.blueGrey)),
            Text(record.regNumber,
                style:
                    const TextStyle(fontSize: 11, color: Colors.blueGrey)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor(record.status).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: _statusColor(record.status).withOpacity(0.4)),
              ),
              child: Text(
                record.status,
                style: TextStyle(
                    color: _statusColor(record.status),
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: Colors.redAccent, size: 20),
              onPressed: () => _delete(record),
              tooltip: 'Delete',
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
