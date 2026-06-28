Week 8 Snapshot — Handling User Input and Events

Summary
Week 8 focuses on touch gesture handling and keyboard input using an Object-Oriented Programming (class-based) approach. Dedicated controller classes are used to separate gesture logic, keyboard handling, input validation, and event logging — following OOP principles of encapsulation and separation of concerns.

What Was Added

1. Controller Classes (lib/controllers/)

   EventLogger class (event_logger.dart)
   * Maintains a timestamped in-memory log of up to 30 events
   * log(String event) — inserts event at the top with HH:MM:SS timestamp
   * events getter — returns an unmodifiable snapshot of the log
   * clear() — resets the log

   GestureController class (gesture_controller.dart)
   * Depends on EventLogger (injected via constructor)
   * onTap() — logs tap event
   * onDoubleTap() — logs double tap event
   * onLongPress() — logs long press / context menu event
   * onSwipeLeft() — logs left swipe (Previous Page)
   * onSwipeRight() — logs right swipe (Next Page)
   * onSwipeUp() — logs upward swipe
   * onSwipeDown() — logs downward swipe

   KeyboardController class (keyboard_controller.dart)
   * Depends on EventLogger (injected via constructor)
   * onTextChanged(text) — logs each keystroke change
   * onKeySubmit(text) — logs Enter / form submission
   * onFocusGained() — logs when text field gains focus
   * onFocusLost() — logs when keyboard is dismissed

   InputValidator class (input_validator.dart)
   * validateUsername(value) — checks empty, min length 3, no spaces
   * validateMessage(value) — checks empty, max 200 characters
   * getValidationResult(username) — returns error or 'Valid username'

2. Input and Gestures Page (lib/pages/gestures_page.dart)

   Three sections on one screen:

   Gesture Zone
   * Large interactive card using Flutter's GestureDetector widget
   * onTap — changes card colour and icon; logs via GestureController
   * onDoubleTap — different colour and icon
   * onLongPress — opens a bottom sheet context menu (Share, Copy, Delete, Info)
   * onPanEnd — detects swipe direction from velocity (left/right/up/down)
   * AnimatedContainer transitions colour smoothly on each gesture

   Keyboard Input Section
   * Form with TextFormField using validator from InputValidator class
   * FocusNode attached — focus gain/loss logged via KeyboardController
   * onChanged logged with each keystroke via KeyboardController
   * TextInputAction.done triggers form submit on keyboard Enter key
   * Live inline validation feedback (green / red) shown below the field
   * Submit button also triggers validation and form submission

   Event Log
   * Scrollable monospace list of all events from EventLogger
   * Most recent event shown in bold blue
   * Older events in grey
   * AppBar trash button clears the log

3. Dashboard Updated (lib/pages/dashboard_page.dart)
   * 'Input and Gestures' card added (10th quick action card, fills empty slot in row 5)

OOP Concepts Demonstrated

| Concept | Where Applied |
|---|---|
| Encapsulation | Each controller class hides its implementation details |
| Dependency Injection | GestureController and KeyboardController receive EventLogger in constructor |
| Single Responsibility | Each class does one thing (log, gesture, keyboard, validate) |
| Method-based Event Handling | Every gesture/key is a dedicated method on its class |
| Separation of Concerns | UI (GesturesPage) separate from logic (controller classes) |

Assessment Checklist

Feature                                       Status
Class-based event handler design              Done — 4 controller classes
Keyboard input handling                       Done — TextFormField, FocusNode, onChanged
Enter / key submission event                  Done — TextInputAction.done, onFieldSubmitted
Input validation class                        Done — InputValidator with 2 validators
Touch gesture handling (tap)                  Done — GestureDetector.onTap
Touch gesture handling (double tap)           Done — GestureDetector.onDoubleTap
Touch gesture handling (long press)           Done — GestureDetector.onLongPress
Touch gesture handling (swipe)                Done — GestureDetector.onPanEnd with velocity
Event logging                                 Done — EventLogger with timestamps
Context menu on long press                    Done — ModalBottomSheet
OOP principles (encapsulation, SRP, DI)       Done

Application Screens

* Welcome screen
* Login screen
* Registration screen
* Dashboard (10 quick action cards)
* My Profile
* My Notes (SQLite CRUD + search)
* My Timetable (SQLite CRUD + search)
* Campus News Feed (DEV.to REST API)
* Attendance (SQLite CRUD, SHA-256 security)
* Reports (aggregated from all sources)
* Input and Gestures (Week 8 — gesture + keyboard demo)
* Settings

Files Submitted

* Source-Code/        Full Flutter project source
* Screenshots/        App screenshots
* README.md           This file


Week 8 — June 2026
