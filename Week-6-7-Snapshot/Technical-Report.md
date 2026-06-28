Technical Report — Smartz Student Portal App
BIT4107 Mobile Application Development — Weeks 6 & 7

Student: Makwae Ethan Hope
Registration Number: BIT/2023/72445


1. Introduction

The Smartz Student Portal is a Flutter mobile application built across seven weeks as part of the BIT4107 Mobile Application Development course. The app allows a university student to manage their profile, notes, class timetable, track attendance, view campus news from a live API, and generate comprehensive reports. This report covers the Week 6 CAT 1 additions and the Week 7 data storage enhancements including database design, password security, and the attendance management feature.


2. Application Overview

| Item | Detail |
|---|---|
| App Name | Smartz Student Portal |
| Platform | Android (Flutter cross-platform) |
| Language | Dart |
| Framework | Flutter 3.x |
| Local Database | SQLite (via sqflite) |
| Key-Value Store | SharedPreferences |
| Security | SHA-256 password hashing (crypto package) |
| API | DEV.to Public REST API |


3. Task 1 — Storage Method Comparison

| Storage Method | Type | Advantages | Disadvantages | Used In App |
|---|---|---|---|---|
| **SharedPreferences** | Key-value pairs | Simple API, fast reads, no schema needed, persists across sessions | No complex queries, no relationships, not encrypted by default | Student profile, session, theme, password flag |
| **SQLite** | Relational database | Full SQL queries, relationships, CRUD, scalable, efficient for structured data | Requires schema design, migration handling, more boilerplate | Notes, Timetable, Attendance |
| **Firebase Firestore** | Cloud NoSQL | Real-time sync, cloud backup, multi-device, offline support | Requires internet for setup, paid beyond free tier, Google dependency | Not used |
| **Internal File Storage** | File system | Good for large binary data (images, PDFs), no size limit | No querying, manual parsing, path management needed | Profile image path stored in SharedPreferences |

**Decision Rationale:** SharedPreferences was chosen for user session and settings because these are simple key-value pairs that need to be read on every app start. SQLite was chosen for notes, timetable, and attendance because these require search, filtering, and count queries.


4. Database Design

4.1 Overview

The app uses SQLite database file `smartz.db` with three tables designed to 3NF (Third Normal Form): each non-key attribute is fully functionally dependent on the primary key only, with no transitive dependencies.

4.2 Table Schemas

**notes table**

| Column | Type | Constraint | Description |
|---|---|---|---|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique note identifier |
| title | TEXT | NOT NULL | Note heading |
| content | TEXT | NOT NULL | Note body text |
| createdAt | TEXT | NOT NULL | ISO date string of creation |

**timetable table**

| Column | Type | Constraint | Description |
|---|---|---|---|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique entry identifier |
| day | TEXT | NOT NULL | Day of week (Monday–Friday) |
| unitCode | TEXT | NOT NULL | Unit code (e.g. BIT4107) |
| unitName | TEXT | NOT NULL | Full unit name |
| startTime | TEXT | NOT NULL | Class start time (HH:MM) |
| endTime | TEXT | NOT NULL | Class end time (HH:MM) |
| room | TEXT | NOT NULL | Lecture room / venue |
| lecturer | TEXT | NOT NULL | Lecturer name |

**attendance table** *(Week 7 addition)*

| Column | Type | Constraint | Description |
|---|---|---|---|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique record identifier |
| studentName | TEXT | NOT NULL | Full name of the student |
| regNumber | TEXT | NOT NULL | Registration number |
| unitName | TEXT | NOT NULL | Unit attended or missed |
| date | TEXT | NOT NULL | Date in YYYY-MM-DD format |
| status | TEXT | NOT NULL | One of: Present, Absent, Late |

4.3 Normalisation

- **1NF:** All columns hold atomic values. No repeating groups. Each row is uniquely identified by the `id` primary key.
- **2NF:** All non-key attributes depend on the full primary key. No partial dependencies (single-column primary keys).
- **3NF:** No transitive dependencies. For example, `unitCode` and `unitName` appear together in timetable but neither derives from the other — they are both attributes of the timetable slot. The student's name and reg number are stored in the attendance table (denormalised for offline use) rather than as a foreign key to avoid requiring a students table in SQLite.

4.4 Database Versioning

The database uses version-based migration:

```dart
return openDatabase(
  path,
  version: 3,
  onCreate: _createTables,
  onUpgrade: (db, oldVersion, newVersion) async {
    await _createTables(db, newVersion);
  },
);
```

- Version 1: notes table
- Version 2: timetable table added
- Version 3: attendance table added (Week 7)


5. Password Security — SHA-256 Hashing

5.1 Implementation

Passwords are hashed using SHA-256 via the `crypto: ^3.0.3` package before being stored in SharedPreferences:

```dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

static String hashPassword(String password) {
  final bytes = utf8.encode(password);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
```

Example: the password `"student123"` is stored as:
`ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f`

5.2 Registration

```dart
await prefs.setString('student_password', hashPassword(password));
await prefs.setBool('password_hashed', true);
```

5.3 Login with Migration

Existing users with plaintext passwords (stored before Week 7) are auto-migrated on their next successful login:

```dart
if (isHashed) {
  return savedPassword == hashPassword(inputPassword);
} else {
  // Migrate on first successful login after update
  if (savedPassword == inputPassword) {
    await prefs.setString('student_password', hashPassword(inputPassword));
    await prefs.setBool('password_hashed', true);
    return true;
  }
  return false;
}
```

This approach ensures backwards compatibility — no user is locked out after the update.

5.4 Change Password

```dart
final matches = isHashed
    ? saved == hashPassword(currentPassword)
    : saved == currentPassword;
if (!matches) return false;
await prefs.setString('student_password', hashPassword(newPassword));
```


6. Week 7 Feature — Attendance Management

6.1 Feature Overview

A complete attendance tracking module was added with the following screens:

- **AttendancePage** — Lists all attendance records with a summary bar (Present / Absent / Late / Total counts), search capability, and swipe-to-delete.
- **AddAttendancePage** — Form pre-filled with the student's name and registration number from SharedPreferences. Fields: Unit Name, Date (date picker), Status (Present / Absent / Late dropdown).

6.2 Database CRUD

| Operation | Method |
|---|---|
| Insert | `insertAttendance(Attendance record)` |
| Read all | `getAllAttendance()` — ordered by date DESC |
| Search | `searchAttendance(query)` — searches unit, date, status |
| Delete | `deleteAttendance(int id)` |
| Summary | `getAttendanceSummary()` — GROUP BY status → `Map<String, int>` |
| Count | `getAttendanceCount()` — total records |

6.3 Reports Integration

The Reports screen now includes an Attendance Summary section showing Present, Late, and Absent session counts alongside the existing Notes and Classes statistics.


7. Features Implemented (Complete List)

7.1 User Interface
- Material Design with consistent blue colour scheme (`#1565C0`)
- Splash screen that auto-routes based on login state
- Welcome screen, Login, Register screens
- Responsive layouts with dark mode support

7.2 Navigation
- `Navigator.push` for forward navigation
- `Navigator.pushReplacement` for auth routing
- 9 screens accessible from Dashboard

7.3 Event Handling
- Form validation on all input screens
- Search bars with real-time filtering
- Date picker for attendance
- Time picker for timetable
- Pull-to-refresh on News Feed and Reports

7.4 Local Storage — SharedPreferences
- Student profile, session management, theme, profile image path
- Password hash flag (`password_hashed`) for migration tracking

7.5 Local Database — SQLite
- 3 tables: notes, timetable, attendance
- Full CRUD + search on all tables
- Count queries and GROUP BY aggregations
- Database version 3 with upgrade handler

7.6 Networking
- DEV.to REST API — GET request, JSON parsing, `Post` model
- Error handling: SocketException, HttpException, FormatException, non-200 codes

7.7 Security
- SHA-256 password hashing via `crypto` package
- Automatic migration from plaintext to hashed on login

7.8 Reports Screen
- Student profile section
- Notes count + 3 most recent notes
- Timetable breakdown by day
- Attendance summary (Present / Late / Absent)
- System info panel


8. Project Structure

```
lib/
├── main.dart
├── models/
│   ├── note.dart
│   ├── timetable_entry.dart
│   ├── post.dart
│   └── attendance.dart           ← Week 7
├── storage/
│   └── local_storage.dart        ← Updated: SHA-256 hashing
├── database/
│   └── database_helper.dart      ← Updated: version 3, attendance table
├── services/
│   └── api_service.dart
└── pages/
    ├── welcome_page.dart
    ├── login_page.dart
    ├── register_page.dart
    ├── dashboard_page.dart        ← Updated: Attendance card added
    ├── profile_page.dart
    ├── notes_page.dart
    ├── add_edit_note_page.dart
    ├── timetable_page.dart
    ├── add_edit_timetable_page.dart
    ├── news_feed_page.dart
    ├── reports_page.dart          ← Updated: attendance stats
    ├── attendance_page.dart       ← Week 7 (new)
    ├── add_attendance_page.dart   ← Week 7 (new)
    ├── courses_page.dart
    ├── assignments_page.dart
    ├── results_page.dart
    ├── settings_page.dart
    └── notifications_page.dart
```


9. Packages Used

| Package | Version | Purpose |
|---|---|---|
| `shared_preferences` | ^2.2.2 | Key-value local storage |
| `sqflite` | ^2.3.2 | SQLite local database |
| `path` | ^1.9.0 | Database file path construction |
| `http` | ^1.2.1 | HTTP networking |
| `image_picker` | ^1.0.7 | Profile photo selection |
| `crypto` | ^3.0.3 | SHA-256 password hashing |


10. Weekly Progression

| Week | Topic | What Was Built |
|---|---|---|
| 1 | Environment Setup | Flutter installed, first app, project structure |
| 2 | Programming & Frameworks | Registration, login, SharedPreferences session management |
| 3 | UI/UX Development | Dashboard, Profile, Settings, dark mode, navigation |
| 4 | Data Management | SQLite Notes (CRUD), Timetable (CRUD), search |
| 5 | Networking | DEV.to API, JSON parsing, 4-type error handling |
| 6 | CAT 1 | Reports screen combining all data sources |
| 7 | Database & Security | SHA-256 password hashing, attendance table (DB v3), attendance CRUD UI |


11. Conclusion

The Smartz Student Portal demonstrates all core mobile development concepts: UI design, navigation, event handling, SharedPreferences and SQLite storage, REST API networking, SHA-256 security, database design to 3NF, and attendance management. The app is functional, handles edge cases, and follows Flutter best practices throughout.
