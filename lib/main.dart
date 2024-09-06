import 'package:flutter/material.dart';
import 'package:spynetra_tmp/pages/login_page.dart';
//import 'package:spynetra_tmp/pages/main_screen.dart';

// PAGE SEQUENCE:
/* main.dart
     -1 login_screen.dart
     -2 main_screen.dart
     -3 case_analysis.dart
     -4 suspect_list.dart
     -5 suspect_details.dart (HANDLE the functionality of generate doc in this)
     -6 pdf_view.dart(the screen after clicking generate doc)

     ADDITIONAL:
     widgets: foldericon styling and functioning
     constants: has the color pallete
     
*/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpyNetra',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
