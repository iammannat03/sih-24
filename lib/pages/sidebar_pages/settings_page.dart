import 'package:flutter/material.dart';
import 'package:spynetra_tmp/pages/main_screen.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/faq_page.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/profile_page.dart';
import 'package:spynetra_tmp/widgets/sidebar.dart'; // Ensure to import the BaseScaffold

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true; // Toggle switch state

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          // Desktop version
          return Scaffold(
            backgroundColor: Colors.black,
            body: Row(
              children: [
                // Sidebar content
                Container(
                  width: 250.0,
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
                      const SizedBox(height: 30.0),
                      // Sidebar options
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildSidebarItem(context, Icons.folder, 'Cases',
                                  const MainScreen(), false),
                              _buildSidebarItem(context, Icons.settings,
                                  'Settings', const SettingsScreen(), true),
                              _buildSidebarItem(context, Icons.person,
                                  'Profile', const ProfilePage(), false),
                              _buildSidebarItem(context, Icons.help, 'FAQ',
                                  const FaqPage(), false),
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
                        color: Colors.grey[850],
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
                                    (route) => false,
                                  );
                                },
                              ),
                              const SizedBox(width: 8.0),
                              const Text(
                                'Settings',
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          // Display Settings content
                          Expanded(
                            child: ListView(
                              children: [
                                _buildSettingCard('Profile', Icons.person, () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ProfilePage(),
                                    ),
                                  );
                                }),
                                _buildSettingCard(
                                  'Notification',
                                  Icons.notifications,
                                  () {},
                                  toggle: true,
                                ),
                                _buildSettingCard('Privacy', Icons.lock, () {}),
                                _buildSettingCard('About', Icons.info, () {}),
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
                            (route) => false,
                          );
                        },
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        'Settings',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  // Display Settings content
                  Expanded(
                    child: ListView(
                      children: [
                        _buildSettingCard('Profile', Icons.person, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          );
                        }),
                        _buildSettingCard(
                          'Notification',
                          Icons.notifications,
                          () {},
                          toggle: true,
                        ),
                        _buildSettingCard('Privacy', Icons.lock, () {}),
                        _buildSettingCard('About', Icons.info, () {}),
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

  Widget _buildSettingCard(String title, IconData icon, VoidCallback onTap,
      {bool toggle = false}) {
    return Card(
      color: Colors.grey[800],
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: toggle
            ? Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                activeColor: Colors.blue,
              )
            : null,
        onTap: onTap,
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
          color: isSelected ? Colors.grey[700] : null,
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
