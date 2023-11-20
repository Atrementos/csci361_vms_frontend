import 'package:csci361_vms_frontend/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

final theme = ThemeData.light().copyWith(
  useMaterial3: true,
  textTheme: GoogleFonts.robotoTextTheme().copyWith(
    bodyLarge: const TextStyle(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 191, 255, 241),
    brightness: Brightness.dark,
    surface: const Color.fromARGB(255, 33, 41, 34),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 45, 57, 47),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Management System',
      theme: theme,
      home: const MainPage(),
    );
  }
}
