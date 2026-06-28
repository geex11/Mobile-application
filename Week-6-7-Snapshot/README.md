Week 6-7 Snapshot — CAT 1 + Database & Security

Summary
Weeks 6 and 7 complete the Smartz Student Portal with a Reports screen (CAT 1), SHA-256 password hashing, a full Attendance management feature with SQLite CRUD, and an updated database schema (version 3, three tables).

What Was Added

Week 6 — CAT 1: Reports Screen

1. Reports Screen (reports_page.dart)
   * Student profile section (reads from SharedPreferences)
   * Summary statistics: total notes count, total timetable classes, total attendance records
   * Recent notes list (latest 3 from SQLite)
   * Timetable breakdown by day (Mon–Fri with class count per day)
   * Attendance summary: Present / Absent / Late counts
   * System info section: storage types, API endpoint, error handling methods
   * Pull-to-refresh support

2. Database count queries (database_helper.dart)
   * getNotesCount()
   * getTimetableCount()
   * getRecentNotes(limit)
   * getTimetableCountByDay()

Week 7 — Data Storage & Security

3. SHA-256 Password Hashing (local_storage.dart, pubspec.yaml)
   * crypto: ^3.0.3 package added
   * hashPassword() uses SHA-256 via dart:convert + crypto
   * Passwords stored as hex digest, never plaintext
   * Auto-migration: existing plaintext passwords upgraded on next login via password_hashed flag

4. Attendance Feature — new SQLite table (database_helper.dart v3)
   * attendance table: id, studentName, regNumber, unitName, date, status
   * Full CRUD: insertAttendance, getAllAttendance, searchAttendance, deleteAttendance
   * Summary query: getAttendanceSummary() — GROUP BY status → Map<String, int>
   * getAttendanceCount()

5. Attendance Page (attendance_page.dart)
   * Lists all records with Present / Absent / Late / Total summary bar at top
   * Real-time search by unit, date, or status
   * Delete with confirmation dialog
   * FAB navigates to Add Attendance form

6. Add Attendance Page (add_attendance_page.dart)
   * Auto-fills student name and reg number from SharedPreferences
   * Unit name text field
   * Date picker (past dates only)
   * Status dropdown: Present, Absent, Late

7. Dashboard Updated (dashboard_page.dart)
   * Attendance card added as 9th quick action

Assessment Checklist

Feature                                    Status
User Interface                             Done
Navigation between screens                 Done
Event handling                             Done
Local data storage (SharedPreferences)     Done — profile, session, theme, image
Local data storage (SQLite v3)             Done — notes + timetable + attendance tables
Password hashing (SHA-256)                 Done — crypto package, auto-migration
Attendance management                      Done — register, store, search, report
Data retrieval and queries                 Done — CRUD + search + COUNT + GROUP BY
Networking / API integration               Done — DEV.to REST API
Error handling                             Done — 4 error types + Retry button
Reports screen                             Done — all data sources combined
Database design (3NF)                      Done — see Technical-Report.md

Application Screens

* Welcome screen
* Login screen
* Registration screen
* Dashboard (9 quick action cards)
* My Profile
* My Notes (SQLite CRUD + search)
* My Timetable (SQLite CRUD + search, grouped by day)
* Campus News Feed (DEV.to API, live articles)
* Attendance (list + summary bar + search + delete)
* Reports (aggregated summary from all sources)
* Settings (dark mode, password change, profile image, logout)
* Courses, Assignments, Results, Notifications

Files Submitted

* Source-Code/        Full Flutter project source
* Screenshots/        App screenshots
* Technical-Report.md Full technical report (Weeks 6 and 7)


Week 6-7 — June 2026
