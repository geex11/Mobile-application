import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final results = [
      {'course': 'BIT4107', 'score': 'A', 'grade': 'Excellent'},
      {'course': 'BIT4108', 'score': 'B+', 'grade': 'Very Good'},
      {'course': 'BIT4109', 'score': 'A-', 'grade': 'Great'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFBBDEFB),
      appBar: AppBar(
        title: const Text('Results', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final item = results[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF1565C0),
                child: Text(item['score'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              title: Text(item['course'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item['grade'] as String),
            ),
          );
        },
      ),
    );
  }
}
