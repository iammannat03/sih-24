import 'package:flutter/material.dart';
import 'package:spynetra_tmp/constants/constants.dart';

class CaseDocumentation extends StatefulWidget {
  const CaseDocumentation({super.key});

  @override
  State<CaseDocumentation> createState() => _CaseDocumentationState();
}

class _CaseDocumentationState extends State<CaseDocumentation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.screen,
      appBar: AppBar(
        backgroundColor: Pallete.appbar,
        title: const Text(
          'CASE DOCUMENTATION',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text(
          'Case documentation will be displayed here',
          style: TextStyle(color: Pallete.text),
        ),
      ),
    );
  }
}
