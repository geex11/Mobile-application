import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/note.dart';
import 'add_edit_note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> _notes = [];
  List<Note> _filtered = [];
  final _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final notes = await DatabaseHelper.getAllNotes();
    setState(() {
      _notes = notes;
      _filtered = notes;
      _isLoading = false;
    });
  }

  void _onSearch() async {
    final q = _searchController.text.trim();
    if (q.isEmpty) {
      setState(() => _filtered = _notes);
    } else {
      final results = await DatabaseHelper.searchNotes(q);
      setState(() => _filtered = results);
    }
  }

  void _openAdd() async {
    final added = await Navigator.push<bool>(
        context, MaterialPageRoute(builder: (_) => const AddEditNotePage()));
    if (added == true) _load();
  }

  void _openEdit(Note note) async {
    final edited = await Navigator.push<bool>(
        context, MaterialPageRoute(builder: (_) => AddEditNotePage(note: note)));
    if (edited == true) _load();
  }

  void _delete(Note note) {
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Note', style: TextStyle(color: Color(0xFF0D47A1))),
        content: Text('Delete "${note.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await DatabaseHelper.deleteNote(note.id!);
              _load();
              messenger.showSnackBar(const SnackBar(
                content: Text('Note deleted'),
                backgroundColor: Colors.red,
              ));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBBDEFB),
      appBar: AppBar(
        title: const Text('My Notes',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text('${_filtered.length} note${_filtered.length == 1 ? '' : 's'}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAdd,
        backgroundColor: const Color(0xFF1565C0),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Note', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1565C0)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.blueGrey),
                        onPressed: () { _searchController.clear(); _onSearch(); },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF1565C0)))
                : _filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notes, size: 64, color: Colors.blue.shade200),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isNotEmpty
                                  ? 'No notes found'
                                  : 'No notes yet\nTap + to add one',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                        itemCount: _filtered.length,
                        itemBuilder: (_, i) => _noteCard(_filtered[i]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _noteCard(Note note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.blue.shade100, blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.note, color: Color(0xFF1565C0)),
        ),
        title: Text(note.title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              note.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
            ),
            const SizedBox(height: 4),
            Text(note.createdAt,
                style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.blueGrey),
          onSelected: (v) {
            if (v == 'edit') _openEdit(note);
            if (v == 'delete') _delete(note);
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit',
                child: Row(children: [Icon(Icons.edit, color: Color(0xFF1565C0), size: 18), SizedBox(width: 8), Text('Edit')])),
            const PopupMenuItem(value: 'delete',
                child: Row(children: [Icon(Icons.delete, color: Colors.red, size: 18), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))])),
          ],
        ),
      ),
    );
  }
}
