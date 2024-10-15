import 'package:flutter/material.dart';
import 'package:qrproject/pages/references.dart';

import 'features.dart';
import 'home_page.dart';

class PricingPage extends StatelessWidget {
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
            automaticallyImplyLeading: false,
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

                },
                child: Text(
                  "Fiyatlandırma",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReferencesPage()),
                  );
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Fiyatlandırma Planlarımız",
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
                    PricingCard(
                      imagePath: 'lib/images/pexels-pixabay-278430.jpg', // AssetImage ile projedeki resim yolu
                      title: "6 Aylık Plan",
                      price: "660 ₺",
                      description: "6 ay boyunca tüm özellikler ve sınırsız erişim.",
                    ),
                    PricingCard(
                      imagePath: 'lib/images/pexels-pixabay-278430.jpg', // Aynı resim ya da farklı bir resim kullanılabilir
                      title: "12 Aylık Plan",
                      price: "1200 ₺",
                      description: "12 ay boyunca tüm özellikler ve sınırsız erişim.",
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

class PricingCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final String description;

  PricingCard({
    required this.imagePath,
    required this.title,
    required this.price,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 160, // 300x160 oranını sağlamak için
              width: double.infinity,
              fit: BoxFit.cover, // Resmin tamamının görünmesi için
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
