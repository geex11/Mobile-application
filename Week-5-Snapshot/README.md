Week 5 Snapshot — Networking

Summary
This week focused on connecting the app to a public REST API, retrieving JSON data, displaying it in a scrollable list, and handling network errors gracefully.

API Used
Name: DEV.to Public API
Endpoint: https://dev.to/api/articles?per_page=30&tag=mobile
Method: HTTP GET
Format: JSON
Authentication: None required

Features Implemented

1. API Connection
   - Connects to the DEV.to public REST API
   - Fetches 30 real English articles tagged with "mobile"

2. JSON Parsing
   - Response body decoded using jsonDecode()
   - Each article mapped into a Post model object

3. RecyclerView Display (ListView.builder)
   - Each article card shows: title, description, tags, author, date, reading time
   - Smooth scrollable list of articles

4. Error Handling
   - SocketException: No internet connection message + Retry button
   - HttpException: Server unreachable message + Retry button
   - FormatException: Invalid response message + Retry button
   - Non-200 status codes: Server error message shown
   - Loading spinner while data is being fetched

5. Search
   - Real-time search filters articles by title, description, or tag

Packages Added
- http: ^1.2.1 - HTTP requests

Project Structure

lib/
├── main.dart
├── models/
│   ├── post.dart               API article model
│   └── ...existing models
├── services/
│   └── api_service.dart        HTTP GET request + error handling
├── pages/
│   ├── news_feed_page.dart     ListView display + search + error screen
│   └── ...existing pages
├── database/
│   └── database_helper.dart
└── storage/
    └── local_storage.dart

Date Submitted
Week 5 — June 2026
