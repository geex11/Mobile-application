import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';
import '../storage/local_storage.dart';
import 'login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  String? _profileImagePath;
  String _studentName = '';
  String _studentEmail = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final dark = await LocalStorage.isDarkMode();
    final imagePath = await LocalStorage.getProfileImage();
    final data = await LocalStorage.getStudent();
    setState(() {
      _isDarkMode = dark;
      _profileImagePath = imagePath;
      _studentName = data['name'] ?? '';
      _studentEmail = data['email'] ?? '';
    });
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      await LocalStorage.saveProfileImage(picked.path);
      setState(() => _profileImagePath = picked.path);
      _showSnack('Profile photo updated!', Colors.green);
    }
  }

  void _showChangePassword() {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Change Password',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1))),
            const SizedBox(height: 20),
            _sheetField(currentController, 'Current Password',
                Icons.lock, true),
            const SizedBox(height: 12),
            _sheetField(newController, 'New Password',
                Icons.lock_outline, true),
            const SizedBox(height: 12),
            _sheetField(confirmController, 'Confirm New Password',
                Icons.lock_reset, true),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (newController.text != confirmController.text) {
                    _showSnack('Passwords do not match', Colors.red);
                    return;
                  }
                  if (newController.text.length < 6) {
                    _showSnack(
                        'Password must be at least 6 characters',
                        Colors.red);
                    return;
                  }
                  final success = await LocalStorage.changePassword(
                    currentPassword: currentController.text,
                    newPassword: newController.text,
                  );
                  Navigator.pop(context);
                  _showSnack(
                    success
                        ? 'Password changed successfully!'
                        : 'Current password is wrong',
                    success ? Colors.green : Colors.red,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Update Password',
                    style: TextStyle(
                        color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.support_agent, color: Color(0xFF1565C0)),
            SizedBox(width: 8),
            Text('Support',
                style: TextStyle(color: Color(0xFF0D47A1))),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SupportItem(
                icon: Icons.school,
                label: 'Course',
                value: 'BIT4107 Mobile App Dev'),
            SizedBox(height: 12),
            _SupportItem(
                icon: Icons.email,
                label: 'Support Email',
                value: 'support@mku.ac.ke'),
            SizedBox(height: 12),
            _SupportItem(
                icon: Icons.phone,
                label: 'Helpdesk',
                value: '+254 700 000 000'),
            SizedBox(height: 12),
            _SupportItem(
                icon: Icons.location_on,
                label: 'Campus',
                value: 'Mount Kenya University, Nairobi'),
            SizedBox(height: 12),
            _SupportItem(
                icon: Icons.info,
                label: 'App Version',
                value: 'v1.0.0'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close',
                style: TextStyle(color: Color(0xFF1565C0))),
          ),
        ],
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFF1565C0)),
            SizedBox(width: 8),
            Text('About',
                style: TextStyle(color: Color(0xFF0D47A1))),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school, size: 60, color: Color(0xFF1565C0)),
            SizedBox(height: 12),
            Text('Smartz App',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1))),
            SizedBox(height: 8),
            Text('Smart Student Portal',
                style: TextStyle(color: Colors.blueGrey)),
            SizedBox(height: 8),
            Text(
                'Built with Flutter for BIT4107\nMobile Application Development',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13, color: Colors.blueGrey)),
            SizedBox(height: 8),
            Text('Version 1.0.0',
                style:
                    TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close',
                style: TextStyle(color: Color(0xFF1565C0))),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout',
            style: TextStyle(color: Color(0xFF0D47A1))),
        content:
            const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await LocalStorage.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red),
            child: const Text('Logout',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  Widget _sheetField(TextEditingController controller, String label,
      IconData icon, bool obscure) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
        filled: true,
        fillColor: Colors.blue.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor:
                              const Color(0xFF1565C0),
                          backgroundImage:
                              _profileImagePath != null
                                ? FileImage(File(_profileImagePath!))
                                : null,
                          child: _profileImagePath == null
                              ? const Icon(Icons.person,
                                  size: 60, color: Colors.white)
                              : null,
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1565C0),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(_studentName,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  Text(_studentEmail,
                      style:
                          const TextStyle(color: Colors.blueGrey)),
                  const SizedBox(height: 4),
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.upload, size: 16),
                    label: const Text('Change Photo'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _sectionTitle('Appearance'),
            _settingsTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              subtitle:
                  _isDarkMode ? 'Currently dark' : 'Currently light',
              trailing: Switch(
                value: _isDarkMode,
                activeColor: const Color(0xFF1565C0),
                onChanged: (val) {
                  setState(() => _isDarkMode = val);
                  MyApp.of(context)?.toggleTheme(val);
                },
              ),
            ),
            const SizedBox(height: 16),

            _sectionTitle('Account'),
            _settingsTile(
              icon: Icons.lock,
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: _showChangePassword,
            ),
            const SizedBox(height: 16),

            _sectionTitle('Help & Info'),
            _settingsTile(
              icon: Icons.support_agent,
              title: 'Support',
              subtitle: 'Contact us & helpdesk info',
              onTap: _showSupport,
            ),
            const SizedBox(height: 8),
            _settingsTile(
              icon: Icons.info_outline,
              title: 'About App',
              subtitle: 'Version, developer info',
              onTap: _showAbout,
            ),
            const SizedBox(height: 24),

            _sectionTitle('Session'),
            _settingsTile(
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Sign out of your account',
              iconColor: Colors.red,
              onTap: _confirmLogout,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
              letterSpacing: 1.2)),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color iconColor = const Color(0xFF1565C0),
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title,
            style:
                const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: const TextStyle(fontSize: 12)),
        trailing: trailing ??
            const Icon(Icons.chevron_right,
                color: Colors.blueGrey),
        onTap: onTap,
      ),
    );
  }
}

class _SupportItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SupportItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1565C0)),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: Colors.blueGrey)),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}
