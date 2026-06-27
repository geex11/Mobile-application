import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  final List<Map<String, dynamic>> _notifications = const [
    {
      'icon': Icons.assignment,
      'title': 'Assignment Due',
      'body': 'BIT4107 Lab Assignment due tomorrow',
      'time': '2 hours ago',
      'color': Colors.orange,
      'read': false,
    },
    {
      'icon': Icons.grade,
      'title': 'Results Released',
      'body': 'Your CAT 1 results are now available',
      'time': '1 day ago',
      'color': Colors.green,
      'read': false,
    },
    {
      'icon': Icons.announcement,
      'title': 'Notice',
      'body': 'University closed on Friday for public holiday',
      'time': '2 days ago',
      'color': Colors.blue,
      'read': true,
    },
    {
      'icon': Icons.event,
      'title': 'Upcoming Event',
      'body': 'Tech Summit at MKU Main Campus next week',
      'time': '3 days ago',
      'color': Colors.purple,
      'read': true,
    },
    {
      'icon': Icons.payment,
      'title': 'Fee Reminder',
      'body': 'Semester 2 fee payment deadline approaching',
      'time': '5 days ago',
      'color': Colors.red,
      'read': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final n = _notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: n['read'] == true
                  ? Colors.white
                  : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (n['color'] as Color).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(n['icon'] as IconData,
                    color: n['color'] as Color),
              ),
              title: Text(n['title'],
                  style: TextStyle(
                      fontWeight: n['read'] == true
                          ? FontWeight.normal
                          : FontWeight.bold,
                      color: const Color(0xFF0D47A1))),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(n['body'],
                      style:
                          const TextStyle(fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(n['time'],
                      style: const TextStyle(
                          fontSize: 11, color: Colors.blueGrey)),
                ],
              ),
              trailing: n['read'] == false
                  ? Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1565C0),
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
