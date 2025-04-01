import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todo_app/frontend/pages/login_screen.dart';
import 'package:todo_app/frontend/pages/show_todos.dart';
import 'package:todo_app/frontend/pages/signup_screen.dart';

import 'frontend/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  runApp(MaterialApp(
    theme: ThemeData(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white,
        selectionHandleColor: Colors.white.withOpacity(0.3),
      ),
    ),
    debugShowCheckedModeBanner: false,
    home: SignupScreen(),
  ));
}