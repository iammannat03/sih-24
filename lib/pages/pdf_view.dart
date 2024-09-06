import 'package:flutter/material.dart';

//screen for displaying the pdf/doc generated
class DocumentDetailScreen extends StatelessWidget {
  final Map<String, String> document;

  const DocumentDetailScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('URL: ${document['url']}'),
            const SizedBox(height: 10.0),
            Text('Username: ${document['username']}'),
            const SizedBox(height: 10.0),
            Text('Password: ${document['password']}'),
          ],
        ),
      ),
    );
  }
}
