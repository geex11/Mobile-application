import 'package:flutter/material.dart';

class AssignmentsPage extends StatelessWidget {
  const AssignmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final assignments = [
      {'title': 'Flutter UI Design', 'status': 'Due Tomorrow', 'color': Colors.orange},
      {'title': 'Shared Preferences Lab', 'status': 'Due Friday', 'color': Colors.green},
      {'title': 'Mobile App Proposal', 'status': 'Due Next Week', 'color': Colors.blue},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFBBDEFB),
      appBar: AppBar(
        title: const Text('Assignments', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          final item = assignments[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: (item['color'] as Color).withOpacity(0.15),
                child: Icon(Icons.assignment, color: item['color'] as Color),
              ),
              title: Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item['status'] as String),
            ),
          );
        },
      ),
    );
  }
}
