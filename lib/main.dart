import 'package:csci361_vms_frontend/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  useMaterial3: true,
  textTheme: GoogleFonts.robotoTextTheme(),
  colorScheme:
      ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 57, 131)),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Management System',
      theme: theme,
      home: const LoginPage(),
    );
  }
}
