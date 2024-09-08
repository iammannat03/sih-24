import 'package:flutter/material.dart';
import 'package:spynetra_tmp/constants/constants.dart';

class PunchScreen extends StatefulWidget {
  final String caseTitle;
  const PunchScreen({super.key, required this.caseTitle});

  @override
  State<PunchScreen> createState() => _PunchScreenState();
}

class _PunchScreenState extends State<PunchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.screen,
      appBar: AppBar(
        title: const Text(
          'Punchnama',
          style: TextStyle(color: Pallete.text),
        ),
        backgroundColor: Pallete.appbar,
        iconTheme: const IconThemeData(
            color: Colors.white), // Set back arrow color here
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Punchnama for ${widget.caseTitle}',
              style: const TextStyle(fontSize: 24, color: Pallete.text),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Go back',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
