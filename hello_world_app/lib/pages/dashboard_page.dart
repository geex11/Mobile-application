import 'package:flutter/material.dart';
import '../storage/local_storage.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'notifications_page.dart';
import 'courses_page.dart';
import 'assignments_page.dart';
import 'results_page.dart';
import 'notes_page.dart';
import 'timetable_page.dart';
import 'news_feed_page.dart';
import 'reports_page.dart';
import 'attendance_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String name = '';
  String email = '';
  String regNumber = '';

  @override
  void initState() {
    super.initState();
    _loadStudent();
  }

  void _loadStudent() async {
    final data = await LocalStorage.getStudent();
    setState(() {
      name = data['name'] ?? 'Student';
      email = data['email'] ?? '';
      regNumber = data['regNumber'] ?? '';
    });
  }

  void _logout() async {
    await LocalStorage.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBBDEFB),
      appBar: AppBar(
        title: const Text('Dashboard',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1565C0),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NotificationsPage())),
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SettingsPage())),
            tooltip: 'Settings',
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                        size: 35, color: Color(0xFF1565C0)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello, $name 👋',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(regNumber,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Quick Actions',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1))),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildQuickAction(
                    icon: Icons.person,
                    label: 'My Profile',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfilePage(
                                name: name,
                                email: email,
                                regNumber: regNumber,
                              )),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAction(
                    icon: Icons.book,
                    label: 'My Courses',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CoursesPage()),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickAction(
                    icon: Icons.assignment,
                    label: 'Assignments',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AssignmentsPage()),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAction(
                    icon: Icons.grade,
                    label: 'Results',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ResultsPage()),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickAction(
                    icon: Icons.notes,
                    label: 'My Notes',
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const NotesPage())),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAction(
                    icon: Icons.calendar_month,
                    label: 'My Timetable',
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const TimetablePage())),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickAction(
                    icon: Icons.newspaper,
                    label: 'Campus News Feed',
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const NewsFeedPage())),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAction(
                    icon: Icons.bar_chart,
                    label: 'Reports',
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ReportsPage())),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickAction(
                    icon: Icons.how_to_reg,
                    label: 'Attendance',
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const AttendancePage())),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 24),

            const Text('Student Details',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1))),
            const SizedBox(height: 12),

            _buildInfoCard(Icons.person, 'Full Name', name),
            const SizedBox(height: 12),
            _buildInfoCard(Icons.email, 'Email', email),
            const SizedBox(height: 12),
            _buildInfoCard(Icons.badge, 'Reg Number', regNumber),
            const SizedBox(height: 12),
            _buildInfoCard(Icons.school, 'Course',
                'BIT4107 Mobile App Development'),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: const Color(0xFF1565C0)),
            const SizedBox(height: 8),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D47A1))),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1565C0)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.blueGrey)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D47A1))),
            ],
          ),
        ],
      ),
    );
  }
}
