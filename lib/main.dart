import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qrproject/firebase_options.dart';
import 'package:qrproject/pages/anasayfa/home_page.dart';
import 'package:qrproject/pages/login_signup.dart'; // AuthPage'i import edin

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Menü Proje',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Başlangıç route
      routes: {
        '/': (context) => const HomePage(), // Ana Sayfa (Başlangıç Sayfası)
        '/auth': (context) => const AuthPage(), // Giriş/Kayıt Sayfası
      },
    );
  }
}
