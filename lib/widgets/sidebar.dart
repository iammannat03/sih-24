import 'package:flutter/material.dart';
import 'package:spynetra_tmp/constants/constants.dart';
import 'package:spynetra_tmp/pages/login_page.dart';
import 'package:spynetra_tmp/pages/main_screen.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/faq_page.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/profile_page.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/settings_page.dart';

//PS: This sidebar widget is only for mobile and tablet. For desktop it is fixed in the main screen.

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation?
      floatingActionButtonLocation; // Add this parameter

  const BaseScaffold({
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation, // Include this in the constructor
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'SpyNetra',
          style: TextStyle(color: Pallete.title),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(color: Pallete.mobilesidebar),
                child: Image.asset(
                  'assets/logo.png',
                )),
            ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: const Icon(
                Icons.home,
                color: Colors.black,
              ),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: const Icon(
                Icons.question_mark,
                color: Colors.black,
              ),
              title: const Text('FAQs'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const FaqPage()),
                );
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: body,
      floatingActionButton: floatingActionButton, // Display the floating button
      floatingActionButtonLocation:
          floatingActionButtonLocation, // Set the location of the floating button
    );
  }
}
