import 'package:flutter/material.dart';
import '../storage/local_storage.dart';

class ProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String regNumber;

  const ProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.regNumber,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Color _primaryTextColor = Color(0xFF102A43);
  static const Color _accentTextColor = Color(0xFF1565C0);

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _regController;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _regController = TextEditingController(text: widget.regNumber);
  }

  void _saveProfile() async {
    setState(() => _isSaving = true);

    final data = await LocalStorage.getStudent();
    await LocalStorage.saveStudent(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      regNumber: _regController.text.trim(),
      password: data['password'] ?? '',
    );

    setState(() {
      _isSaving = false;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBBDEFB),
      appBar: AppBar(
        title: const Text('My Profile',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
                _isEditing ? Icons.close : Icons.edit,
                color: Colors.white),
            onPressed: () =>
                setState(() => _isEditing = !_isEditing),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person,
                      size: 80, color: Color(0xFF1565C0)),
                ),
                if (_isEditing)
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
            const SizedBox(height: 16),

            Text(widget.name,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _primaryTextColor)),
            const SizedBox(height: 4),
            Text(widget.regNumber,
                style: const TextStyle(
                    fontSize: 14,
                    color: _primaryTextColor,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 30),

            _buildField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person,
              enabled: _isEditing,
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: _emailController,
              label: 'Email Address',
              icon: Icons.email,
              enabled: _isEditing,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: _regController,
              label: 'Registration Number',
              icon: Icons.badge,
              enabled: _isEditing,
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: TextEditingController(
                  text: 'BIT4107 Mobile App Development'),
              label: 'Course',
              icon: Icons.school,
              enabled: false,
            ),
            const SizedBox(height: 30),

            if (_isEditing)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveProfile,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: _isSaving
                      ? const CircularProgressIndicator(
                          color: Colors.white)
                      : const Text('Save Changes',
                          style: TextStyle(
                              fontSize: 16, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                        const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              label,
              style: const TextStyle(
                color: _accentTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextField(
            controller: controller,
            enabled: true,
            readOnly: !enabled,
            keyboardType: keyboardType,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(
              color: _primaryTextColor,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: label,
              hintStyle: const TextStyle(
                color: Color(0xFF78909C),
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(icon, color: _accentTextColor),
              filled: true,
              fillColor: enabled ? Colors.white : const Color(0xFFF5F9FF),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
