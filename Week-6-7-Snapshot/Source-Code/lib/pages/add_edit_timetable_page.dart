import 'package:flutter/material.dart';
import '../models/timetable_entry.dart';
import '../database/database_helper.dart';

class AddEditTimetablePage extends StatefulWidget {
  final TimetableEntry? entry;
  const AddEditTimetablePage({super.key, this.entry});

  @override
  State<AddEditTimetablePage> createState() => _AddEditTimetablePageState();
}

class _AddEditTimetablePageState extends State<AddEditTimetablePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _roomController;
  late TextEditingController _lecturerController;
  late String _selectedDay;
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  bool _isSaving = false;

  bool get _isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();
    _codeController     = TextEditingController(text: widget.entry?.unitCode ?? '');
    _nameController     = TextEditingController(text: widget.entry?.unitName ?? '');
    _roomController     = TextEditingController(text: widget.entry?.room ?? '');
    _lecturerController = TextEditingController(text: widget.entry?.lecturer ?? '');
    _selectedDay        = widget.entry?.day ?? TimetableEntry.days.first;

    if (widget.entry != null) {
      _startTime = _parseTime(widget.entry!.startTime);
      _endTime   = _parseTime(widget.entry!.endTime);
    }
  }

  TimeOfDay _parseTime(String t) {
    final parts = t.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) { _startTime = picked; } else { _endTime = picked; }
      });
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final entry = TimetableEntry(
      id: widget.entry?.id,
      day: _selectedDay,
      unitCode: _codeController.text.trim(),
      unitName: _nameController.text.trim(),
      startTime: _formatTime(_startTime),
      endTime: _formatTime(_endTime),
      room: _roomController.text.trim(),
      lecturer: _lecturerController.text.trim(),
    );

    if (_isEditing) {
      await DatabaseHelper.updateTimetableEntry(entry);
    } else {
      await DatabaseHelper.insertTimetableEntry(entry);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBBDEFB),
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Class' : 'Add Class',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
              // Day picker
              DropdownButtonFormField<String>(
                initialValue: _selectedDay,
                decoration: InputDecoration(
                  labelText: 'Day',
                  prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF1565C0)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: TimetableEntry.days
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedDay = v!),
              ),
              const SizedBox(height: 16),
              _field(_codeController, 'Unit Code', Icons.code,
                  validator: (v) => v!.trim().isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              _field(_nameController, 'Unit Name', Icons.school,
                  validator: (v) => v!.trim().isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              // Time pickers
              Row(children: [
                Expanded(child: _timeTile('Start Time', _startTime, () => _pickTime(true))),
                const SizedBox(width: 12),
                Expanded(child: _timeTile('End Time', _endTime, () => _pickTime(false))),
              ]),
              const SizedBox(height: 16),
              _field(_roomController, 'Room / Venue', Icons.room,
                  validator: (v) => v!.trim().isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              _field(_lecturerController, 'Lecturer', Icons.person,
                  validator: (v) => v!.trim().isEmpty ? 'Required' : null),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _save,
                  icon: Icon(_isEditing ? Icons.save : Icons.add, color: Colors.white),
                  label: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _isEditing ? 'Save Changes' : 'Add Class',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeTile(String label, TimeOfDay time, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.access_time, color: Color(0xFF1565C0), size: 18),
              const SizedBox(width: 6),
              Text(
                _formatTime(time),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1)),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Color(0xFF102A43), fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
