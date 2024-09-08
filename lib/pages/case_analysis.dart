import 'package:flutter/material.dart';
import 'package:spynetra_tmp/pages/call_detail_record.dart';
import 'package:spynetra_tmp/pages/case_documentation.dart';
import 'package:spynetra_tmp/pages/main_screen.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/faq_page.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/profile_page.dart';
import 'package:spynetra_tmp/pages/punch_screen.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/settings_page.dart';
import 'package:spynetra_tmp/pages/suspect_list.dart';
import 'package:spynetra_tmp/widgets/folders.dart';
import 'package:spynetra_tmp/widgets/sidebar.dart'; // Ensure to import the BaseScaffold

class CaseAnalysis extends StatefulWidget {
  final String caseTitle;

  const CaseAnalysis({super.key, required this.caseTitle});

  @override
  CaseAnalysisState createState() => CaseAnalysisState();
}

class CaseAnalysisState extends State<CaseAnalysis> {
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
                          child: Image.asset(
                              'assets/logo.png'), // Replace with your logo widget
                        ),
                      ),
                      const SizedBox(height: 30.0), // Space below the logo
                      // Sidebar options
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildSidebarItem(context, 0, Icons.folder,
                                  'Cases', const MainScreen()),
                              _buildSidebarItem(context, 1, Icons.settings,
                                  'Settings', const SettingsScreen()),
                              _buildSidebarItem(context, 2, Icons.person,
                                  'Profile', const ProfilePage()),
                              _buildSidebarItem(context, 3, Icons.help, 'FAQ',
                                  const FaqPage()),
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
                                  Navigator.pop(context);
                                },
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                widget.caseTitle,
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          // Grid view for folders
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 5, // 5 folders for desktop
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                              childAspectRatio: 1.2,
                              children: [
                                FolderIcon(
                                  text: 'Punchnama',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PunchScreen(
                                            caseTitle: widget.caseTitle),
                                      ),
                                    );
                                  },
                                  iconSize: 80,
                                ),
                                FolderIcon(
                                  text: 'Case Documentation',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CaseDocumentation(),
                                      ),
                                    );
                                  },
                                  iconSize: 80,
                                ),
                                FolderIcon(
                                  text: 'Suspect List',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SuspectList(
                                            caseTitle: widget.caseTitle),
                                      ),
                                    );
                                  },
                                  iconSize: 80,
                                ),
                                FolderIcon(
                                  text: 'CDR List',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CallDetailRecord(),
                                      ),
                                    );
                                  },
                                  iconSize: 80,
                                ),
                                // Add more folders if needed
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
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        widget.caseTitle,
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: constraints.maxWidth < 600
                          ? 2
                          : 3, // 2 for mobile, 3 for tablet
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.2,
                      children: [
                        FolderIcon(
                          text: 'Punchnama',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PunchScreen(caseTitle: widget.caseTitle),
                              ),
                            );
                          },
                          iconSize: 80,
                        ),
                        FolderIcon(
                          text: 'Case Documentation',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CaseDocumentation(),
                              ),
                            );
                          },
                          iconSize: 80,
                        ),
                        FolderIcon(
                          text: 'Suspect List',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SuspectList(caseTitle: widget.caseTitle),
                              ),
                            );
                          },
                          iconSize: 80,
                        ),
                        FolderIcon(
                          text: 'CDR List',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CallDetailRecord(),
                              ),
                            );
                          },
                          iconSize: 80,
                        ),
                        // Add more folders if needed
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

  Widget _buildSidebarItem(BuildContext context, int index, IconData icon,
      String text, Widget destination) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => destination,
          ),
        );
      },
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(
          icon,
          color: Colors.grey,
        ),
        title: Text(
          text,
          style: const TextStyle(color: Colors.grey),
        ),
        tileColor: Colors.black,
      ),
    );
  }
}
