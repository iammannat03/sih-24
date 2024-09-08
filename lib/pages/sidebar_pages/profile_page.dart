import 'package:flutter/material.dart';
import 'package:spynetra_tmp/pages/login_page.dart';
import 'package:spynetra_tmp/pages/main_screen.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/faq_page.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/settings_page.dart';
import 'package:spynetra_tmp/widgets/sidebar.dart'; // Ensure to import the BaseScaffold

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values for the text fields
    _usernameController.text = 'manav-sharma';
    _emailController.text = 'manav_sharma@example.com';
    _phoneController.text = '987-456-2390';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
                Container(
                  width: 250.0,
                  color: Colors.black,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: 230,
                          height: 100,
                          child: Image.asset('assets/logo.png'),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildSidebarItem(context, Icons.folder, 'Cases',
                                  const MainScreen()),
                              _buildSidebarItem(context, Icons.settings,
                                  'Settings', const SettingsScreen()),
                              _buildSidebarItem(context, Icons.person,
                                  'Profile', const ProfilePage()),
                              _buildSidebarItem(
                                  context, Icons.help, 'FAQ', const FaqPage()),
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                const SizedBox(width: 8.0),
                                const Text(
                                  'Profile',
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24.0),
                            Center(
                              child: Column(
                                children: [
                                  // Profile Picture
                                  const CircleAvatar(
                                    radius: 50,
                                    backgroundImage: AssetImage(
                                        'assets/profile_placeholder.png'),
                                  ),
                                  const SizedBox(height: 16.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Implement image picker functionality
                                    },
                                    child: const Text('Change Profile Picture'),
                                  ),
                                  const SizedBox(height: 24.0),
                                ],
                              ),
                            ),
                            // Username
                            _buildProfileField('Username', _usernameController),
                            const SizedBox(height: 16.0),
                            // Email
                            _buildProfileField('Email', _emailController),
                            const SizedBox(height: 16.0),
                            // Phone Number
                            _buildProfileField(
                                'Phone Number', _phoneController),
                            const SizedBox(height: 24.0),
                            const Text(
                              'Change Password',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            const SizedBox(height: 16.0),
                            // Current Password
                            _buildProfileField(
                                'Current Password', _currentPasswordController,
                                isPassword: true),
                            const SizedBox(height: 16.0),
                            // New Password
                            _buildProfileField(
                                'New Password', _newPasswordController,
                                isPassword: true),
                            const SizedBox(height: 16.0),
                            // Confirm New Password
                            _buildProfileField(
                                'Confirm Password', _confirmPasswordController,
                                isPassword: true),
                            const SizedBox(height: 24.0),
                            // Save Changes Button
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => const LoginScreen(),
                                  //   ),
                                  // );
                                },
                                child: const Text('Save Changes'),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: const Text('Log Out'),
                              ),
                            ),
                          ],
                        ),
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
            body: SingleChildScrollView(
              child: Padding(
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
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 8.0),
                        const Text(
                          'Profile',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    Center(
                      child: Column(
                        children: [
                          // Profile Picture
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage('assets/profile_placeholder.png'),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              // Implement image picker functionality
                            },
                            child: const Text('Change Profile Picture'),
                          ),
                          const SizedBox(height: 24.0),
                        ],
                      ),
                    ),
                    _buildProfileField('Username', _usernameController),
                    const SizedBox(height: 16.0),
                    _buildProfileField('Email', _emailController),
                    const SizedBox(height: 16.0),
                    _buildProfileField('Phone Number', _phoneController),
                    const SizedBox(height: 24.0),
                    const Text(
                      'Change Password',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const SizedBox(height: 16.0),
                    _buildProfileField(
                        'Current Password', _currentPasswordController,
                        isPassword: true),
                    const SizedBox(height: 16.0),
                    _buildProfileField('New Password', _newPasswordController,
                        isPassword: true),
                    const SizedBox(height: 16.0),
                    _buildProfileField(
                        'Confirm Password', _confirmPasswordController,
                        isPassword: true),
                    const SizedBox(height: 24.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle saving changes
                        },
                        child: const Text('Save Changes'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Log Out',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildSidebarItem(
      BuildContext context, IconData icon, String text, Widget destination) {
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
          color: text == 'Profile' ? Colors.grey[700] : null,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(6.0),
          leading:
              Icon(icon, color: text == 'Profile' ? Colors.white : Colors.grey),
          title: Text(
            text,
            style: TextStyle(
                color: text == 'Profile' ? Colors.white : Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.grey[700],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: const EdgeInsets.all(16.0),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
