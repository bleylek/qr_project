import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qrproject/firebase_options.dart';
import 'package:qrproject/pages/home_page.dart';
import 'package:qrproject/pages/login_signup.dart';  // AuthPage'i import edin

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Menü Proje',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',  // Başlangıç route
      routes: {
        '/': (context) => HomePage(),      // Ana Sayfa (Başlangıç Sayfası)
        '/auth': (context) => AuthPage(),  // Giriş/Kayıt Sayfası
      },
    );
  }
}
