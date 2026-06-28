import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/attendance.dart';
import '../storage/local_storage.dart';

class AddAttendancePage extends StatefulWidget {
  const AddAttendancePage({super.key});

  @override
  State<AddAttendancePage> createState() => _AddAttendancePageState();
}

class _AddAttendancePageState extends State<AddAttendancePage> {
  final _formKey = GlobalKey<FormState>();
  final _unitController = TextEditingController();

  String _studentName = '';
  String _regNumber = '';
  String _selectedStatus = 'Present';
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadStudent();
  }

  @override
  void dispose() {
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _loadStudent() async {
    final data = await LocalStorage.getStudent();
    if (!mounted) return;
    setState(() {
      _studentName = data['name'] ?? '';
      _regNumber = data['regNumber'] ?? '';
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1565C0),
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final record = Attendance(
      studentName: _studentName,
      regNumber: _regNumber,
      unitName: _unitController.text.trim(),
      date: _formatDate(_selectedDate),
      status: _selectedStatus,
    );

    await DatabaseHelper.insertAttendance(record);
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBBDEFB),
      appBar: AppBar(
        title: const Text('Record Attendance',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student info (read-only)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Student',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(
                      _studentName.isEmpty ? 'Loading...' : _studentName,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D47A1)),
                    ),
                    const SizedBox(height: 8),
                    const Text('Registration Number',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(
                      _regNumber.isEmpty ? 'Loading...' : _regNumber,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D47A1)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Unit name
              _buildLabel('Unit / Class Name'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _unitController,
                decoration: _inputDecoration('e.g. BIT4107 Mobile App Dev'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter unit name' : null,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),

              // Date picker
              _buildLabel('Date'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Color(0xFF1565C0), size: 20),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(_selectedDate),
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF0D47A1),
                            fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down,
                          color: Color(0xFF1565C0)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Status dropdown
              _buildLabel('Attendance Status'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedStatus,
                    items: Attendance.statuses.map((s) {
                      final color = s == 'Present'
                          ? Colors.green
                          : s == 'Absent'
                              ? Colors.red
                              : Colors.orange;
                      return DropdownMenuItem(
                        value: s,
                        child: Row(
                          children: [
                            Icon(
                              s == 'Present'
                                  ? Icons.check_circle
                                  : s == 'Absent'
                                      ? Icons.cancel
                                      : Icons.access_time,
                              color: color,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(s,
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedStatus = v);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Save Attendance',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0D47A1)));
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: Color(0xFF1565C0), width: 2),
      ),
    );
  }
}
