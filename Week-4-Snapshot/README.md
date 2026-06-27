Week 4 Snapshot — Data Management

Summary
This week focused on data management using both SharedPreferences (for small data) and SQLite (for structured records) with full CRUD operations and search functionality.

Features Implemented

Local Storage (SharedPreferences)
- Login session persistence
- Dark mode preference
- Profile image path
- Student profile data

SQLite Database (sqflite)
Two tables managed with full CRUD + search:

1. My Notes
   - Add notes with title and content
   - Edit existing notes
   - Delete notes with confirmation dialog
   - Search notes by title or content
   - Displays date/time created

2. My Timetable
   - Add weekly class entries (day, unit code, unit name, start/end time, room, lecturer)
   - Edit existing entries
   - Delete entries with confirmation dialog
   - Search by day, unit, or lecturer
   - Grouped by day (Monday to Friday) with colour coding
   - Time picker for start and end time

CRUD Operations
- Create: FAB button opens Add form with validation
- Read: ListView displays all records (RecyclerView equivalent)
- Update: Edit form pre-filled with existing data
- Delete: Confirmation dialog before removing record

Packages Added
- sqflite: ^2.3.2 - SQLite database
- path: ^1.9.0 - Database path resolution

Project Structure

lib/
├── main.dart
├── database/
│   └── database_helper.dart     SQLite CRUD for notes and timetable
├── models/
│   ├── student.dart
│   ├── note.dart
│   └── timetable_entry.dart
├── pages/
│   ├── notes_page.dart          Notes list with search
│   ├── add_edit_note_page.dart  Add/Edit note form
│   ├── timetable_page.dart      Timetable grouped by day
│   ├── add_edit_timetable_page.dart  Add/Edit class form
│   └── ...existing pages
└── storage/
    └── local_storage.dart

Date Submitted
Week 4 — June 2026
