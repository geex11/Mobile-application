# Week 3 Snapshot — UI/UX Development

## Summary
This week focused on UI/UX design and building a fully functional Flutter prototype with multiple screens, working navigation, form validation, and responsive design.

## Screens Implemented (10 screens)
1. **Welcome Page** — App landing screen with branding and navigation to Login/Register
2. **Login Page** — Email and password login with forgot password (password reset)
3. **Register Page** — Student registration with name, email, reg number, and password
4. **Dashboard Page** — Home screen showing student info and quick action cards
5. **Profile Page** — View and edit student profile details
6. **Settings Page** — Dark mode toggle, change password, profile photo, support, about
7. **Notifications Page** — List of read/unread notifications
8. **Courses Page** — List of enrolled courses
9. **Assignments Page** — List of assignments with due dates
10. **Results Page** — Academic results per course

## Features Added This Week
- Multi-screen navigation with MaterialPageRoute transitions
- Form validation (empty field checks, password length, password match)
- Alerts and feedback via SnackBars and dialogs
- Session-based login persistence using SharedPreferences
- Dark mode toggle (persisted across app restarts)
- Profile image picker from gallery
- Password change and password reset flows
- Responsive layouts using SingleChildScrollView and flexible widgets

## Packages Used
- `shared_preferences: ^2.2.2` — local storage for session and student data
- `image_picker: ^1.0.4` — profile photo from gallery

## Project Structure
```
lib/
├── main.dart               # App entry, theme management, splash decider
├── models/
│   └── student.dart        # Student data model
├── pages/
│   ├── welcome_page.dart
│   ├── login_page.dart
│   ├── register_page.dart
│   ├── dashboard_page.dart
│   ├── profile_page.dart
│   ├── settings_page.dart
│   ├── notifications_page.dart
│   ├── courses_page.dart
│   ├── assignments_page.dart
│   └── results_page.dart
└── storage/
    └── local_storage.dart  # SharedPreferences CRUD, session, theme, password
```

## Date Submitted
Week 3 — June 2026
