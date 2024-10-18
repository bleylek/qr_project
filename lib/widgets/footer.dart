import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color.fromARGB(137, 176, 91, 91),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "© 2024 QR Menü. Tüm Hakları Saklıdır.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "İletişim: info@qrmenu.com",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.instagram),
                color: Colors.white,
                onPressed: () {
                  // Instagram sayfasına yönlendir
                },
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.twitter),
                color: Colors.white,
                onPressed: () {
                  // Twitter sayfasına yönlendir
                },
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.youtube),
                color: Colors.white,
                onPressed: () {
                  // YouTube sayfasına yönlendir
                },
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.linkedin),
                color: Colors.white,
                onPressed: () {
                  // LinkedIn sayfasına yönlendir
                },
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.tiktok),
                color: Colors.white,
                onPressed: () {
                  // TikTok sayfasına yönlendir
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  // Ana sayfaya yönlendir
                },
                child: const Text(
                  "Ana Sayfa",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {
                  // Fiyatlandırma sayfasına yönlendir
                },
                child: const Text(
                  "Fiyatlandırma",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {
                  // Gizlilik Politikası sayfasına yönlendir
                },
                child: const Text(
                  "Gizlilik Politikası",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {
                  // İletişim sayfasına yönlendir
                },
                child: const Text(
                  "İletişim",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
