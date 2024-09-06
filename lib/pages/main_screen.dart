//this is the main screen which has the options to add new case. Used shared pref for storing the state of page

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spynetra_tmp/widgets/folders.dart';
import 'package:spynetra_tmp/constants/constants.dart';
import 'package:spynetra_tmp/pages/case_analysis.dart';

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
          return {
            'title': caseData,
          };
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

//this is the dialog box that pops up for adding new case

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

  /* void deleteCase(int index) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Case'),
          content: const Text('Are you sure you want to delete this case?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      setState(() {
        _cases.removeAt(index);
        _saveCases();
      });
    }
  }
 */

//here is the layout of the screen, arrangement of folders on the page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const SizedBox(height: 30),
                  const Text(
                    "Cases",
                    style: TextStyle(fontSize: 24),
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
                              crossAxisCount: crossAxisCount,
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
          );
        },
      ),

      //add-case button

      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          double buttonWidth =
              constraints.maxWidth < 600 ? constraints.maxWidth * 0.8 : 200.0;

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
}
