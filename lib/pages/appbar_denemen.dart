import 'package:flutter/material.dart';
import 'package:qrproject/pages/ozellikler/features.dart';
import 'package:qrproject/pages/anasayfa/home_page.dart';
import 'package:qrproject/pages/referanslar/references.dart';

class Appbar extends StatelessWidget {
  const Appbar({super.key, required this.currentPage});

  final String currentPage;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        "QR Menü",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const HomePage()), // FeaturesPage'e yönlendir
            );
          },
          child: const Text(
            "Ana Sayfa",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const FeaturesPage()), // FeaturesPage'e yönlendir
            );
          },
          child: const Text(
            "Özellikler",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "Fiyatlandırma",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReferencesPage()),
            );
          },
          child: const Text(
            "Referanslar",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            // Giriş sayfasına yönlendir
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text("Giriş Yap"),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            // Kayıt ol sayfasına yönlendir
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text("Kayıt Ol"),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
