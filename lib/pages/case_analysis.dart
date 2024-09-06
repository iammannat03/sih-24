//this is the page which has case details. Panchnama, Sus list etc. below handle the punchnama folder click, and others too except the sus list

import 'package:flutter/material.dart';
import 'package:spynetra_tmp/widgets/folders.dart';
import 'package:spynetra_tmp/pages/suspect_list.dart';

class CaseAnalysis extends StatelessWidget {
  final String caseTitle;

  const CaseAnalysis({super.key, required this.caseTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CASE ANALYSIS"), // Display the case title
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount;
          if (constraints.maxWidth < 600) {
            crossAxisCount = 2; // Mobile: 2 folders per row
          } else if (constraints.maxWidth < 1200) {
            crossAxisCount = 3; // Tablet: 3 folders per row
          } else {
            crossAxisCount = 5; // Desktop: 5 folders per row
          }

          double iconSize = 80;

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                child: Column(
                  children: [
                    Text(
                      caseTitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.2,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        FolderIcon(
                          text: 'Punchnama',
                          onTap: () {
                            // Handle Punchnama folder click
                          },
                          iconSize: iconSize,
                        ),
                        FolderIcon(
                          text: 'Case Documentation',
                          onTap: () {
                            // Handle Case Documentation folder click
                          },
                          iconSize: iconSize,
                        ),
                        FolderIcon(
                          text: 'Suspect List',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SuspectList(caseTitle: caseTitle),
                              ),
                            );
                          },
                          iconSize: iconSize,
                        ),
                        FolderIcon(
                          text: 'CDR List',
                          onTap: () {
                            // handle CDR List folder click
                          },
                          iconSize: iconSize,
                        ),
                        // add more folders if needed
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
