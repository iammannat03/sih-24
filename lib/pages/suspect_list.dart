//this page allows the user to add suspects. Used shared pref

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spynetra_tmp/widgets/folders.dart';
import 'package:spynetra_tmp/constants/constants.dart';
import 'package:spynetra_tmp/pages/suspect_details.dart';

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

//dialog box for adding a suspect that requires the name of the suspect

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.caseTitle), // Display the case title
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
                    "Suspects",
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 24.0),
                  Expanded(
                    child: _suspects.isEmpty
                        ? const Center(
                            child: Text('No suspects added yet.'),
                          )
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 0.0,
                              mainAxisSpacing: 0.0,
                              childAspectRatio: 1.2,
                            ),
                            itemCount: _suspects.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SuspectDetail(
                                        suspectName: _suspects[index],
                                      ),
                                    ),
                                  );
                                },
                                child: FolderIcon(
                                  text: _suspects[index],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SuspectDetail(
                                          suspectName: _suspects[index],
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
}
