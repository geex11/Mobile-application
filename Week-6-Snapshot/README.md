Week 6 Snapshot — CAT 1 Assessment

Summary
This week combines all skills learned across the semester into a complete, working student portal application (Smartz App). A Reports screen was added to aggregate data from all local sources and display a unified summary.

What Was Added This Week

1. Reports Screen (reports_page.dart)
   - Student profile section (reads from SharedPreferences)
   - Summary statistics: total notes count, total timetable classes
   - Recent notes list (latest 3 from SQLite)
   - Timetable breakdown by day (Mon–Fri with class count per day)
   - System info section: storage types, API endpoint, error handling methods
   - Pull-to-refresh support

2. Database additions (database_helper.dart)
   - getNotesCount() — SQL COUNT query on notes table
   - getTimetableCount() — SQL COUNT query on timetable table
   - getRecentNotes(limit) — fetches N most recent notes
   - getTimetableCountByDay() — GROUP BY day query returning Map<String, int>

Assessment Checklist

Feature                           Status
User Interface                    Done
Navigation between screens        Done
Event handling                    Done
Local data storage (SQLite)       Done - notes + timetable tables
Local data storage (SharedPrefs)  Done - session, profile, theme
Data retrieval                    Done - CRUD + search + count queries
Networking / API integration      Done - DEV.to REST API
Error handling                    Done - 4 error types + Retry button
Reports screen                    Done

Application Screens

- Welcome screen
- Login screen
- Registration screen
- Dashboard (8 quick action cards)
- My Profile
- My Notes (SQLite CRUD + search)
- My Timetable (SQLite CRUD + search, grouped by day)
- Campus News Feed (DEV.to API, live articles)
- Reports (aggregated summary from all sources)
- Settings (dark mode, password, profile image, logout)
- Courses, Assignments, Results, Notifications

Files Submitted

- Source-Code/   Full Flutter project source
- Screenshots/   App screenshots
- Technical-Report.md  Full technical report

Date Submitted
Week 6 — June 2026
