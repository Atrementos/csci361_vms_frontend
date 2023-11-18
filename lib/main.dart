import 'package:csci361_vms_frontend/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

final theme = ThemeData.dark().copyWith(
  useMaterial3: true,
  textTheme: GoogleFonts.robotoTextTheme(),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 255, 151, 151),
    brightness: Brightness.dark,
    surface: const Color.fromARGB(255, 76, 45, 45),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 102, 60, 60),
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
