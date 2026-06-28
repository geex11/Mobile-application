import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // SHA-256 password hashing
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Save student record — password stored as SHA-256 hash
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
    await prefs.setString('student_password', hashPassword(password));
    await prefs.setBool('password_hashed', true);
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

  // Login — compares SHA-256 hashes (auto-migrates plaintext passwords)
  static Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('student_email');
    final savedPassword = prefs.getString('student_password');
    final isHashed = prefs.getBool('password_hashed') ?? false;

    if (savedEmail != email) return false;

    final inputHash = hashPassword(password);

    if (isHashed) {
      if (savedPassword == inputHash) {
        await prefs.setBool('is_logged_in', true);
        return true;
      }
      return false;
    } else {
      // Migrate plaintext password to hash on successful login
      if (savedPassword == password) {
        await prefs.setString('student_password', inputHash);
        await prefs.setBool('password_hashed', true);
        await prefs.setBool('is_logged_in', true);
        return true;
      }
      return false;
    }
  }

  // Check if session is active
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // Logout — only clears session, keeps student data
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
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

  // Change password — compares hashes, stores new hash
  static Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('student_password');
    final isHashed = prefs.getBool('password_hashed') ?? false;

    final matches = isHashed
        ? saved == hashPassword(currentPassword)
        : saved == currentPassword;

    if (!matches) return false;

    await prefs.setString('student_password', hashPassword(newPassword));
    await prefs.setBool('password_hashed', true);
    return true;
  }

  static Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('student_email');
    if (savedEmail != email) return false;
    await prefs.setString('student_password', hashPassword(newPassword));
    await prefs.setBool('password_hashed', true);
    return true;
  }
}
