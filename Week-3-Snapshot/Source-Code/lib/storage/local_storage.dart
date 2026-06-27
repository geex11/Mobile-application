import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // Save student record
  static Future<void> saveStudent({
    required String name,
    required String email,
    required String regNumber,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('student_name', name);
    await prefs.setString('student_email', email);
    await prefs.setString('student_reg', regNumber);
    await prefs.setString('student_password', password);
  }

  // Get saved student
  static Future<Map<String, String?>> getStudent() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('student_name'),
      'email': prefs.getString('student_email'),
      'regNumber': prefs.getString('student_reg'),
      'password': prefs.getString('student_password'),
    };
  }

  // Check if student is registered
  static Future<bool> isRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('student_email') != null;
  }

  // Login check — also saves session
  static Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('student_email');
    final savedPassword = prefs.getString('student_password');
    if (savedEmail == email && savedPassword == password) {
      await prefs.setBool('is_logged_in', true); // ← save session
      return true;
    }
    return false;
  }

  // Check if session is active
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // Logout — only clears session, keeps student data
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false); // ← only clears session
  }

  // Clear all data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Theme management
  static Future<void> saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDarkMode);
  }

  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_dark_mode') ?? false;
  }

  // Profile image management
  static Future<void> saveProfileImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', imagePath);
  }

  static Future<String?> getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_image');
  }

  // Password management
  static Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('student_password');
    
    if (saved != currentPassword) {
      return false;
    }
    
    await prefs.setString('student_password', newPassword);
    return true;
  }

  static Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('student_email');
    
    if (savedEmail != email) {
      return false;
    }
    
    await prefs.setString('student_password', newPassword);
    return true;
  }
}