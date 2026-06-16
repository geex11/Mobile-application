# Week 2 Submission

## Summary
Implemented authentication system with local storage, user registration, and login functionality. Built a clean UI with three main pages and integrated SharedPreferences for persistent data storage.

## Features Completed

### 1. **Project Structure**
- Created organized folder structure:
  - `lib/pages/` - Login, Register, and Home pages
  - `lib/models/` - Student data model
  - `lib/storage/` - Local storage management

### 2. **Authentication System**
- User registration with validation (name, email, registration number, password)
- Login functionality with credential validation
- Session management (login/logout without clearing registration data)
- Remember registration data for quick login

### 3. **Pages Implemented**
- **Login Page** - Email & password input with navigation to register page
- **Register Page** - Full name, email, registration number, and password fields
- **Home Page** - Welcome page after successful login

### 4. **Local Storage**
- Implemented SharedPreferences for persistent data storage
- Save student registration data
- Validate login credentials
- Session tracking (isLoggedIn flag)
- Logout clears only session, keeps registration data
- ClearAll method available for complete data wipe

### 5. **UI/UX Improvements**
- Custom styled text fields with icons
- Loading states during authentication
- Error messages and feedback (SnackBars)
- Blue and light blue color scheme
- Responsive layout with SafeArea

## Dependencies Added
- `shared_preferences: ^2.2.2` - For local data persistence

## Changes from Week 1
- Created comprehensive authentication system
- Added pages structure (login, register, home)
- Implemented local storage using SharedPreferences
- Built Student data model with JSON serialization
- Styled UI with custom colors and icons
- Added session management for user authentication

## Technical Details

### Data Persistence Flow
```
Registration → Save to SharedPreferences → Local Device Storage
Login → Validate from Saved Data → Set Session Flag
Logout → Clear Session Flag Only → Keep Registration Data
```

### Authentication Methods
- `saveStudent()` - Save registration data
- `login()` - Validate credentials and set session
- `isLoggedIn()` - Check active session
- `logout()` - Clear session only
- `clearAll()` - Complete data wipe

## Testing Completed
- ✓ Registration with all fields
- ✓ Login with saved credentials
- ✓ Session persistence
- ✓ Error handling and validation
- ✓ UI responsiveness

## Known Notes
- Password stored in plain text (consider encryption for production)
- Single user registration (can be extended to multi-user)
- No network API integration (local only)

## Directory Contents
- `Source-Code/` - Complete Flutter project with all features
- `Screenshots/` - Evidence screenshots of working features
- `README.md` - This week's summary

## Date Submitted
June 16, 2026
