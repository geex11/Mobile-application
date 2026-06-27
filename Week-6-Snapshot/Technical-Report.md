# Technical Report — Smartz Student Portal App
## BIT4107 Mobile Application Development — CAT 1

**Student:** [Your Name]
**Registration Number:** [Your Reg Number]
**Date:** June 2026

---

## 1. Introduction

The Smartz Student Portal is a Flutter mobile application built over six weeks as part of the BIT4107 Mobile Application Development course. The app allows a university student to manage their profile, notes, class timetable, view campus news from a live API, and generate a summary report of their data.

---

## 2. Application Overview

| Item | Detail |
|---|---|
| App Name | Smartz Student Portal |
| Platform | Android (Flutter cross-platform) |
| Language | Dart |
| Framework | Flutter |
| Database | SQLite (via sqflite) + SharedPreferences |
| API | DEV.to Public REST API |

---

## 3. Features Implemented

### 3.1 User Interface (Week 1 & 3)
- Material Design with a consistent blue colour scheme (`#1565C0`)
- Splash screen that auto-routes based on login state
- Welcome screen with Login and Register options
- Responsive layouts using `Column`, `Row`, `Expanded`, `SingleChildScrollView`
- Dark mode toggle in Settings

### 3.2 Navigation Between Screens (Week 3)
- `Navigator.push` for forward navigation
- `Navigator.pushReplacement` for login/logout routing
- Named screens: Welcome → Login/Register → Dashboard → Profile, Notes, Timetable, News Feed, Reports, Settings

### 3.3 Event Handling (Week 2 & 3)
- Form validation on all input screens (login, register, add note, add class)
- Button tap handlers for CRUD operations
- Search bars with real-time `TextEditingController` listeners
- Time pickers (`showTimePicker`) for timetable class scheduling
- Pull-to-refresh and AppBar refresh button on News Feed and Reports

### 3.4 Local Data Storage — SharedPreferences (Week 2)
Used for:
- Student registration data (name, email, reg number, password)
- Session management (login / logout)
- Dark mode preference
- Profile image path

Key methods in `LocalStorage`:
- `saveStudent()`, `getStudent()` — persist registration
- `login()`, `isLoggedIn()`, `logout()` — session control
- `saveTheme()`, `isDarkMode()` — theme preference

### 3.5 Local Database — SQLite (Week 4)
Two tables in `smartz.db`:

**notes table**
| Column | Type |
|---|---|
| id | INTEGER PRIMARY KEY AUTOINCREMENT |
| title | TEXT |
| content | TEXT |
| createdAt | TEXT |

**timetable table**
| Column | Type |
|---|---|
| id | INTEGER PRIMARY KEY AUTOINCREMENT |
| day | TEXT |
| unitCode | TEXT |
| unitName | TEXT |
| startTime | TEXT |
| endTime | TEXT |
| room | TEXT |
| lecturer | TEXT |

Full CRUD operations implemented for both tables. Search across all relevant fields. Timetable entries ordered by day (Mon–Fri) then start time.

### 3.6 Data Retrieval (Week 4)
- Notes: `getAllNotes()`, `searchNotes()`, `getRecentNotes()`
- Timetable: `getAllTimetableEntries()`, `searchTimetable()`, `getTimetableCountByDay()`
- Count queries: `getNotesCount()`, `getTimetableCount()`
- SharedPreferences reads on every Dashboard load for student name and reg number

### 3.7 Networking / API Integration (Week 5)
- **API:** DEV.to Public REST API
- **Endpoint:** `https://dev.to/api/articles?per_page=30&tag=mobile`
- **Method:** HTTP GET
- **Package:** `http: ^1.2.1`
- **Response format:** JSON array of article objects
- **Parsing:** `jsonDecode()` → mapped into `Post` model using `Post.fromJson()`
- **Timeout:** 10 seconds

Defensive null handling in `Post.fromJson()`:
```dart
title: json['title']?.toString() ?? '',
authorName: (json['user'] as Map<String, dynamic>?)?['name']?.toString() ?? 'Unknown',
tags: (json['tag_list'] as List<dynamic>?)
        ?.map((t) => t?.toString() ?? '')
        .where((t) => t.isNotEmpty)
        .toList() ?? [],
```

### 3.8 Error Handling (Week 5)
Four network error types handled:

| Error | Cause | User Message |
|---|---|---|
| `SocketException` | No internet connection | "No internet connection. Please check your network." |
| `HttpException` | Server unreachable | "Could not reach the server. Try again later." |
| `FormatException` | Malformed response body | "Invalid response from server." |
| Non-200 status | Server-side error | "Server error: [status code]" |

All error states show a Retry button. Loading spinner shown during fetch.

### 3.9 Reports Screen (Week 6)
A summary screen that reads from all data sources:
- Student profile (SharedPreferences)
- Notes count and 3 most recent notes (SQLite)
- Total class count and breakdown by day (SQLite)
- System info: storage methods, API endpoint, error handling types

---

## 4. Project Structure

```
lib/
├── main.dart                        App entry, dark mode, SplashDecider
├── models/
│   ├── student.dart                 Student data model
│   ├── note.dart                    Note model (id, title, content, createdAt)
│   ├── timetable_entry.dart         TimetableEntry model (7 fields)
│   └── post.dart                    API article model with fromJson()
├── storage/
│   └── local_storage.dart           SharedPreferences wrapper
├── database/
│   └── database_helper.dart         SQLite helper, 2 tables, full CRUD
├── services/
│   └── api_service.dart             HTTP GET + error handling
└── pages/
    ├── welcome_page.dart
    ├── login_page.dart
    ├── register_page.dart
    ├── dashboard_page.dart
    ├── profile_page.dart
    ├── notes_page.dart
    ├── add_edit_note_page.dart
    ├── timetable_page.dart
    ├── add_edit_timetable_page.dart
    ├── news_feed_page.dart
    ├── reports_page.dart            ← Week 6 addition
    ├── courses_page.dart
    ├── assignments_page.dart
    ├── results_page.dart
    ├── settings_page.dart
    └── notifications_page.dart
```

---

## 5. Packages Used

| Package | Version | Purpose |
|---|---|---|
| `shared_preferences` | ^2.2.2 | Key-value local storage |
| `sqflite` | ^2.3.2 | SQLite local database |
| `path` | ^1.9.0 | Database file path construction |
| `http` | ^1.2.1 | HTTP networking |
| `image_picker` | ^1.0.7 | Profile photo selection |

---

## 6. Weekly Progression

| Week | Topic | What Was Built |
|---|---|---|
| 1 | Environment Setup | Flutter installed, first app created, project structure |
| 2 | Programming & Frameworks | Registration, login, SharedPreferences session management |
| 3 | UI/UX Development | Full Dashboard, Profile, Settings, dark mode, navigation |
| 4 | Data Management | SQLite Notes (full CRUD), Timetable (full CRUD), search |
| 5 | Networking | DEV.to API integration, JSON parsing, error handling |
| 6 | CAT 1 | Reports screen combining all data sources, technical report |

---

## 7. How the Application Works

1. **First launch:** App shows Welcome screen with Login and Register buttons.
2. **Registration:** Student enters name, email, reg number and password — saved to SharedPreferences.
3. **Login:** Credentials verified against SharedPreferences. Session flag set on success.
4. **Dashboard:** Loads student name and reg number. Shows 8 quick action cards.
5. **My Notes:** Lists all notes from SQLite. FAB opens add form. Long-press or menu allows edit/delete.
6. **My Timetable:** Lists classes grouped by day with colour coding. FAB to add. Search by unit/day/lecturer.
7. **Campus News Feed:** Fetches 30 live articles from DEV.to API. Search filters in real-time. Error state shows Retry.
8. **Reports:** Reads from all sources — displays student profile, note count, recent notes, classes per day, and system info.
9. **Settings:** Change password, toggle dark mode, pick profile image, logout.

---

## 8. Conclusion

The Smartz Student Portal demonstrates all core mobile development concepts covered in this course: UI design, multi-screen navigation, event handling, local storage with both SharedPreferences and SQLite, live API networking with proper error handling, and data aggregation in a reports screen. The application is functional, handles edge cases, and follows Flutter best practices throughout.
