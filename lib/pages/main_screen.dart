import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/faq_page.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/profile_page.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/settings_page.dart';
// import 'package:spynetra_tmp/pages/punch_screen.dart';
import 'package:spynetra_tmp/widgets/folders.dart';
import 'package:spynetra_tmp/constants/constants.dart';
import 'package:spynetra_tmp/pages/case_analysis.dart';
import 'package:spynetra_tmp/widgets/sidebar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  List<Map<String, String>> _cases = [];

  @override
  void initState() {
    super.initState();
    _loadCases();
  }

  Future<void> _loadCases() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedCases = prefs.getStringList('cases');
    if (savedCases != null) {
      setState(() {
        _cases = savedCases.map((caseString) {
          final caseData = caseString;
          return {'title': caseData};
        }).toList();
      });
    }
  }

  Future<void> _saveCases() async {
    final prefs = await SharedPreferences.getInstance();
    final caseStrings = _cases.map((caseData) {
      return '${caseData['title']}';
    }).toList();
    await prefs.setStringList('cases', caseStrings);
  }

  void _showAddCaseDialog() {
    TextEditingController caseTitleController = TextEditingController();

    String? errorMessage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Case'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: caseTitleController,
                decoration: InputDecoration(
                  hintText: 'Enter case title',
                  errorText: errorMessage,
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                if (caseTitleController.text.isEmpty) {
                  setState(() {
                    errorMessage = 'Title is required';
                  });
                } else {
                  setState(() {
                    _cases.add({
                      'title': caseTitleController.text,
                    });
                    _saveCases();
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
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
                        color: Colors.grey[
                            850], // Grey container with smooth round edges
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Cases",
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                          const SizedBox(height: 24.0),
                          Expanded(
                            child: _cases.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No cases added yet.',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      crossAxisSpacing: 16.0,
                                      mainAxisSpacing: 16.0,
                                      childAspectRatio: 1.2,
                                    ),
                                    itemCount: _cases.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CaseAnalysis(
                                                caseTitle: _cases[index]
                                                    ['title']!,
                                              ),
                                            ),
                                          );
                                        },
                                        child: FolderIcon(
                                          text: _cases[index]['title']!,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CaseAnalysis(
                                                  caseTitle: _cases[index]
                                                      ['title']!,
                                                ),
                                              ),
                                            );
                                          },
                                          iconSize: 100,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: SizedBox(
              width: 200.0,
              height: 50.0,
              child: ElevatedButton(
                onPressed: _showAddCaseDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.plusButton,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  ' + Add Case',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        } else {
          // Mobile and tablet version with sidebar
          return BaseScaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth < 600 ? 16.0 : 32.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Cases",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  const SizedBox(height: 24.0),
                  Expanded(
                    child: _cases.isEmpty
                        ? const Center(
                            child: Text('No cases added yet.'),
                          )
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: constraints.maxWidth < 600
                                  ? 2
                                  : 3, // 2 for mobile, 3 for tablet
                              crossAxisSpacing: 0.0,
                              mainAxisSpacing: 0.0,
                              childAspectRatio: 1.2,
                            ),
                            itemCount: _cases.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CaseAnalysis(
                                        caseTitle: _cases[index]['title']!,
                                      ),
                                    ),
                                  );
                                },
                                child: FolderIcon(
                                  text: _cases[index]['title']!,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CaseAnalysis(
                                          caseTitle: _cases[index]['title']!,
                                        ),
                                      ),
                                    );
                                  },
                                  iconSize: 100,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            floatingActionButton: LayoutBuilder(
              builder: (context, constraints) {
                double buttonWidth = constraints.maxWidth < 600
                    ? constraints.maxWidth * 0.8
                    : 200.0;

                return SizedBox(
                  width: buttonWidth,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: _showAddCaseDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallete.plusButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      ' + Add Case',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
          color: text == 'Cases'
              ? Colors.grey[700]
              : null, // Grey color for "Cases" item
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(6.0),
          leading: Icon(
            icon,
            color: text == 'Cases' ? Colors.white : Colors.grey,
          ),
          title: Text(
            text,
            style: TextStyle(
              color: text == 'Cases' ? Colors.white : Colors.grey,
              fontWeight: text == 'Cases' ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
