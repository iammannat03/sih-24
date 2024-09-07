import 'package:flutter/material.dart';

class CaseDocumentation extends StatefulWidget {
  const CaseDocumentation({super.key});

  @override
  State<CaseDocumentation> createState() => _CaseDocumentationState();
}

class _CaseDocumentationState extends State<CaseDocumentation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CASE DOCUMENTATION'),
      ),
      body: const Center(
        child: Text('Case documentation will be displayed here'),
      ),
    );
  }
}
