import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spynetra_tmp/widgets/folders.dart'; // Assuming FolderIcon widget exists
import 'package:spynetra_tmp/constants/constants.dart'; // Assuming Pallete and constants are defined
import 'package:spynetra_tmp/pages/pdf_view.dart'; // Assuming PDF viewing is handled elsewhere

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

  // Pop-up for adding details of a document
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
                        errorText: errorMessage != null &&
                                urlController.text.isEmpty
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
                        // Navigate to Document Detail Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DocumentDetailScreen(
                              document: {
                                'url': urlController.text,
                                'username': usernameController.text,
                                'password': passwordController.text,
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

  // Displaying the created document folders
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details for ${widget.suspectName}'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount;
          if (constraints.maxWidth < 600) {
            crossAxisCount = 2;
          } else if (constraints.maxWidth < 1200) {
            crossAxisCount = 3;
          } else {
            crossAxisCount = 5;
          }

          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth < 600 ? 16.0 : 32.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Documents",
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 24.0),
                  Expanded(
                    child: _documents.isEmpty
                        ? const Center(
                            child: Text('No documents added yet.'),
                          )
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
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
                                    // Handle folder tap to show document details
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
          );
        },
      ),
      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          double buttonWidth =
              constraints.maxWidth < 600 ? constraints.maxWidth * 0.8 : 200.0;

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
}
