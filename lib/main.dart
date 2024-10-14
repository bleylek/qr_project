import 'package:flutter/material.dart';
import 'package:qrproject/pages/home_page.dart';


void main() {
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
      home: HomePage(),  // HomePage'i başlangıç sayfası olarak belirtiyoruz.
    );
  }
}
