import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'home_page.dart'; // Simge kullanmak için FontAwesome

class FeaturesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "QR Menü",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()), // FeaturesPage'e yönlendir
                  );
                },
                child: Text(
                  "Ana Sayfa",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeaturesPage()), // FeaturesPage'e yönlendir
                  );
                },
                child: Text(
                  "Özellikler",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Fiyatlandırma sayfasına yönlendir
                },
                child: Text(
                  "Fiyatlandırma",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Referanslar sayfasına yönlendir
                },
                child: Text(
                  "Referanslar",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(width: 16),
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
                child: Text("Giriş Yap"),
              ),
              SizedBox(width: 8),
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
                child: Text("Kayıt Ol"),
              ),
              SizedBox(width: 16),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Uygulamamızın Temel Özellikleri",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [

                    FeatureCard(

                      icon: FontAwesomeIcons.qrcode,
                      title: "Kolay QR Kod",
                      description:
                      "Müşterileriniz menüye hızlı ve kolayca erişebilir.",

                    ),
                    FeatureCard(
                      icon: FontAwesomeIcons.mobileAlt,
                      title: "Mobil Uyumluluk",
                      description:
                      "Tüm cihazlarda kusursuz çalışan mobil uyumlu tasarım.",
                    ),
                    FeatureCard(
                      icon: FontAwesomeIcons.lock,
                      title: "Güvenli Altyapı",
                      description:
                      "Verileriniz SSL ile şifrelenir ve güvenli bir şekilde saklanır.",
                    ),
                    FeatureCard(
                      icon: FontAwesomeIcons.chartLine,
                      title: "Analiz ve Raporlama",
                      description:
                      "Siparişler ve müşteri istatistikleri ile performansınızı takip edin.",
                    ),
                    FeatureCard(
                      icon: FontAwesomeIcons.cogs,
                      title: "Kullanıcı Dostu Yönetim",
                      description:
                      "Menü ve siparişlerinizi hızlıca düzenleyin ve yönetin.",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  FeatureCard({required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueAccent.withOpacity(0.8),
              child: FaIcon(
                icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
