import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spynetra_tmp/pages/main_screen.dart';
import 'package:spynetra_tmp/pages/pdf_view.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/faq_page.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/profile_page.dart';
import 'package:spynetra_tmp/pages/sidebar_pages/settings_page.dart';
import 'package:spynetra_tmp/widgets/folders.dart';
import 'package:spynetra_tmp/constants/constants.dart';
import 'package:spynetra_tmp/widgets/sidebar.dart';

class SuspectDetail extends StatefulWidget {
  final String suspectName;

  const SuspectDetail({super.key, required this.suspectName});

  @override
  SuspectDetailState createState() => SuspectDetailState();
}

class SuspectDetailState extends State<SuspectDetail> {
  List<Map<String, String>> _documents = [];

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedDocuments =
        prefs.getStringList('documents_${widget.suspectName}');
    if (savedDocuments != null) {
      setState(() {
        _documents = savedDocuments.map((documentString) {
          final docData = documentString.split('|');
          return {
            'url': docData[0],
            'username': docData[1],
            'password': docData[2],
          };
        }).toList();
      });
    }
  }

  Future<void> _saveDocuments() async {
    final prefs = await SharedPreferences.getInstance();
    final docStrings = _documents.map((docData) {
      return '${docData['url']}|${docData['username']}|${docData['password']}';
    }).toList();
    await prefs.setStringList('documents_${widget.suspectName}', docStrings);
  }

  void _showAddDocumentDialog() {
    TextEditingController urlController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Add Document'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: urlController,
                      decoration: InputDecoration(
                        hintText: 'Enter URL',
                        errorText:
                            errorMessage != null && urlController.text.isEmpty
                                ? 'URL is required'
                                : null,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: 'Enter Username',
                        errorText: errorMessage != null &&
                                usernameController.text.isEmpty
                            ? 'Username is required'
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        errorText: errorMessage != null &&
                                passwordController.text.isEmpty
                            ? 'Password is required'
                            : null,
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Generate Document'),
                  onPressed: () {
                    setState(() {
                      if (urlController.text.isEmpty ||
                          usernameController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        setStateDialog(() {
                          errorMessage = 'All fields are required';
                        });
                      } else {
                        _documents.add({
                          'url': urlController.text,
                          'username': usernameController.text,
                          'password': passwordController.text,
                        });
                        _saveDocuments();
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DocumentDetailScreen(
                              document: {
                                'url': urlController.text,
                                'username': usernameController.text,
                                'password': usernameController.text,
                              },
                            ),
                          ),
                        ).then((_) {
                          setState(() {});
                        });
                      }
                    });
                  },
                ),
              ],
            );
          },
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
          // Desktop Layout
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
                                  Navigator.pop(context);
                                },
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                'Documents for ${widget.suspectName}',
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          Expanded(
                            child: _documents.isEmpty
                                ? const Center(
                                    child: Text('No documents added yet.',
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
                                    itemCount: _documents.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        child: FolderIcon(
                                          text: _documents[index]['url']!,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DocumentDetailScreen(
                                                  document: _documents[index],
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
            floatingActionButton: LayoutBuilder(
              builder: (context, constraints) {
                double buttonWidth = constraints.maxWidth * 0.2;
                return SizedBox(
                  width: buttonWidth,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: _showAddDocumentDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallete.plusButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      ' + Add Document',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        } else {
          // Mobile and Tablet Layout
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
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Documents for ${widget.suspectName}',
                            style: const TextStyle(
                                fontSize: 25, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Expanded(
                    child: _documents.isEmpty
                        ? const Center(
                            child: Text('No documents added yet.',
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
                            itemCount: _documents.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: FolderIcon(
                                  text: _documents[index]['url']!,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DocumentDetailScreen(
                                          document: _documents[index],
                                        ),
                                      ),
                                    );
                                  },
                                  iconSize: 80,
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
                double buttonWidth =
                    isMobile ? constraints.maxWidth * 0.8 : 200.0;
                return SizedBox(
                  width: buttonWidth,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: _showAddDocumentDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallete.plusButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      ' + Add Document',
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
          color: Colors.white,
        ),
        title: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
        tileColor: Colors.black,
      ),
    );
  }
}
