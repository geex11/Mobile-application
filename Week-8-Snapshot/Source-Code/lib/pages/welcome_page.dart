import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBBDEFB),
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Logo
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.school,
                      size: 90, color: Color(0xFF1565C0)),
                ),
                const SizedBox(height: 40),

                // Title
                const Text(
                  'Welcome to Smart\nStudent Portal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),

                const Text(
                  'BIT4107 Mobile Application Development',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1565C0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                // Divider
                Container(
                    width: 60, height: 3, color: const Color(0xFF1565C0)),
                const SizedBox(height: 20),

                const Text(
                  'Explore modern mobile development with Flutter',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.blueGrey,
                  ),
                ),

                const Spacer(),

                // Get Started button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    ),
                    icon:
                        const Icon(Icons.arrow_forward, color: Colors.white),
                    label: const Text('Get Started',
                        style:
                            TextStyle(fontSize: 18, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("New student? ",
                        style: TextStyle(color: Colors.blueGrey)),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterPage()),
                      ),
                      child: const Text(
                        'Register here',
                        style: TextStyle(
                          color: Color(0xFF1565C0),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
