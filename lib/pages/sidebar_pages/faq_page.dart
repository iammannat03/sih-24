import 'package:flutter/material.dart';
import 'package:spynetra_tmp/pages/main_screen.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/profile_page.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/settings_page.dart';
import 'package:spynetra_tmp/widgets/sidebar.dart'; // Ensure to import the BaseScaffold

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          // Desktop version
          return Scaffold(
            backgroundColor: Colors.black, // Set the background color to black
            body: Row(
              children: [
                // Sidebar content
                Container(
                  width: 250.0, // Width of the sidebar
                  color: Colors.black,
                  child: Column(
                    children: [
                      // Logo at the top
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: 230,
                          height: 100,
                          child: Image.asset('assets/logo.png'),
                        ),
                      ),
                      const SizedBox(height: 30.0), // Space below the logo
                      // Sidebar options
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildSidebarItem(context, Icons.folder, 'Cases',
                                  const MainScreen(), false),
                              _buildSidebarItem(context, Icons.settings,
                                  'Settings', const SettingsScreen(), false),
                              _buildSidebarItem(context, Icons.person,
                                  'Profile', const ProfilePage(), false),
                              _buildSidebarItem(context, Icons.help, 'FAQ',
                                  const FaqPage(), true), // FAQ is selected
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[
                            850], // Grey container with smooth round edges
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainScreen()),
                                    (route) =>
                                        false, // Removes all routes until the MainScreen
                                  );
                                },
                              ),
                              const SizedBox(width: 8.0),
                              const Text(
                                'FAQs',
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          // Display FAQ content
                          Expanded(
                            child: ListView(
                              children: [
                                _buildFaqItem('What is this app used for?',
                                    'This app helps manage and analyze cases efficiently.'),
                                _buildFaqItem(
                                    'How can I add my own document for suspect?',
                                    'To add your own document for suspect, click on the suspect\'s document -> Upload ZIP Folder'),
                                _buildFaqItem(
                                    'How to view the documentation of suspect?',
                                    'To view a suspect\'s documentation, click on the Documentation folder after opening a case folder.'),
                                _buildFaqItem('How do I add a new case?',
                                    'Use the "Add" button on the main screen to create a new case.'),
                                _buildFaqItem('Can I customize the sidebar?',
                                    'Yes, you can customize the sidebar by navigating to the settings page.'),
                                _buildFaqItem('How do I contact support?',
                                    'For support, go to the settings page and find the contact support option.'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // Mobile and tablet version
          return BaseScaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth < 600 ? 16.0 : 32.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()),
                            (route) =>
                                false, // Removes all routes until the MainScreen
                          );
                        },
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        'FAQs',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  // Display FAQ content
                  Expanded(
                    child: ListView(
                      children: [
                        _buildFaqItem('What is this app used for?',
                            'This app helps manage and analyze cases efficiently.'),
                        _buildFaqItem(
                            'How can I add my own document for suspect?',
                            'To add your own document for suspect, click on the suspect\'s document -> Upload ZIP Folder'),
                        _buildFaqItem(
                            'How to view the documentation of suspect?',
                            'To view a suspect\'s documentation, click on the Documentation folder after opening a case folder.'),
                        _buildFaqItem('How do I add a new case?',
                            'Use the "Add" button on the main screen to create a new case.'),
                        _buildFaqItem('Can I customize the sidebar?',
                            'Yes, you can customize the sidebar by navigating to the settings page.'),
                        _buildFaqItem('How do I contact support?',
                            'For support, go to the settings page and find the contact support option.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(BuildContext context, IconData icon, String text,
      Widget destination, bool isSelected) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => destination,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.grey[700]
              : null, // Grey color for the selected FAQ item
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(6.0),
          leading: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey,
          ),
          title: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
