// Import necessary packages
import 'package:flutter/material.dart'; // Flutter's core UI library
import 'package:qrproject/pages/initialization_page/initialization_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Library for persistent storage
import 'package:firebase_core/firebase_core.dart'; // Firebase core library for initialization
import 'package:qrproject/firebase_options.dart'; // Custom configuration for Firebase initialization
import 'package:qrproject/pages/anasayfa/home_page.dart'; // Home page widget
import 'package:qrproject/pages/login_signup.dart'; // Authentication (login/signup) page widget
import 'package:qrproject/pages/login_first_page.dart'; // Initial page after login widget

// Entry point of the Flutter application
void main() async {
  // Ensure that widget binding is initialized before interacting with plugins
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options for the app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Provides configuration for different platforms
  );

  // Obtain an instance of SharedPreferences for persistent storage
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if the user is logged in by retrieving the 'isLoggedIn' flag
  // If 'isLoggedIn' is null, default to 'false'
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Run the application, passing the login state to the main widget
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

// Main application widget that takes the user's login state as input
class MyApp extends StatelessWidget {
  // Property to store the login status
  final bool isLoggedIn;

  // Constructor for the MyApp widget, requiring the login state
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build the MaterialApp widget, which is the root of the app
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disables the "Debug" banner in the top-right corner
      title: 'QR Menü Proje', // Title of the app displayed in task switcher
      theme: ThemeData(
        primarySwatch: Colors.blue, // Sets the primary color theme to blue
      ),
      // Sets the home page of the app based on the login state
      home: isLoggedIn ? LoginFirstPage() : const AuthPage(),
      // Defines routes for navigation within the app
      routes: {
        '/home': (context) => const HomePage(), // Route to the home page
        '/auth': (context) => const AuthPage(), // Route to the authentication page
        '/logout': (context) => const LoginFirstPage(), // Route to the logout or initial page
      },
    );
  }
}
