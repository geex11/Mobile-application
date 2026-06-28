import 'package:flutter/material.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = [
      {'title': 'BIT4107', 'subtitle': 'Mobile Application Development', 'icon': Icons.phone_android},
      {'title': 'BIT4108', 'subtitle': 'Database Systems', 'icon': Icons.storage},
      {'title': 'BIT4109', 'subtitle': 'Software Engineering', 'icon': Icons.engineering},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFBBDEFB),
      appBar: AppBar(
        title: const Text('My Courses', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF1565C0),
                child: Icon(course['icon'] as IconData, color: Colors.white),
              ),
              title: Text(course['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(course['subtitle'] as String),
              trailing: const Icon(Icons.chevron_right, color: Color(0xFF1565C0)),
            ),
          );
        },
      ),
    );
  }
}
