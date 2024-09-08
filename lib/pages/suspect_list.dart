import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/faq_page.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/profile_page.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/settings_page.dart';
import 'package:spynetra_tmp/widgets/folders.dart';
import 'package:spynetra_tmp/constants/constants.dart';
import 'package:spynetra_tmp/pages/suspect_details.dart';
import 'package:spynetra_tmp/pages/main_screen.dart';
import 'package:spynetra_tmp/widgets/sidebar.dart'; // Ensure to import the BaseScaffold

class SuspectList extends StatefulWidget {
  final String caseTitle;

  const SuspectList({super.key, required this.caseTitle});

  @override
  SuspectListState createState() => SuspectListState();
}

class SuspectListState extends State<SuspectList> {
  List<String> _suspects = [];

  @override
  void initState() {
    super.initState();
    _loadSuspects();
  }

  Future<void> _loadSuspects() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _suspects = prefs.getStringList(widget.caseTitle) ?? [];
    });
  }

  Future<void> _saveSuspects() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(widget.caseTitle, _suspects);
  }

  void _addSuspect(String name) {
    setState(() {
      _suspects.add(name);
      _saveSuspects();
    });
  }

  void _showAddSuspectDialog() {
    TextEditingController controller = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Suspect'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter suspect name',
              errorText: errorMessage,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _addSuspect(controller.text);
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    errorMessage = 'Name is required';
                  });
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
        bool isDesktop = constraints.maxWidth >= 1200;
        bool isMobile = constraints.maxWidth < 600;

        if (isDesktop) {
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
                                  Navigator.pop(
                                      context); // Go back to the previous page
                                },
                              ),
                              Text(
                                widget.caseTitle,
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          Expanded(
                            child: _suspects.isEmpty
                                ? const Center(
                                    child: Text('No suspects added yet.',
                                        style: TextStyle(color: Colors.white)),
                                  )
                                : GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      crossAxisSpacing: 16.0,
                                      mainAxisSpacing: 16.0,
                                      childAspectRatio: 1.2,
                                    ),
                                    itemCount: _suspects.length,
                                    itemBuilder: (context, index) {
                                      return FolderIcon(
                                        text: _suspects[index],
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SuspectDetail(
                                                      suspectName:
                                                          _suspects[index]),
                                            ),
                                          );
                                        },
                                        iconSize: 80,
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
            floatingActionButton: LayoutBuilder(
              builder: (context, constraints) {
                double buttonWidth = constraints.maxWidth * 0.2;
                return SizedBox(
                  width: buttonWidth,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: _showAddSuspectDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallete.plusButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      ' + Add Suspect',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        } else {
          // Mobile and tablet version
          return BaseScaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : 32.0,
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
                          Navigator.pop(
                              context); // Go back to the previous page
                        },
                      ),
                      Text(
                        widget.caseTitle,
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Expanded(
                    child: _suspects.isEmpty
                        ? const Center(
                            child: Text('No suspects added yet.',
                                style: TextStyle(color: Colors.white)),
                          )
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isMobile ? 2 : 3,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                              childAspectRatio: 1.2,
                            ),
                            itemCount: _suspects.length,
                            itemBuilder: (context, index) {
                              return FolderIcon(
                                text: _suspects[index],
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SuspectDetail(
                                          suspectName: _suspects[index]),
                                    ),
                                  );
                                },
                                iconSize: 80,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            floatingActionButton: LayoutBuilder(
              builder: (context, constraints) {
                double buttonWidth =
                    isMobile ? constraints.maxWidth * 0.8 : 200.0;
                return SizedBox(
                  width: buttonWidth,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: _showAddSuspectDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallete.plusButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      ' + Add Suspect',
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
