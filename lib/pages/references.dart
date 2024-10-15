import 'package:flutter/material.dart';
import 'package:qrproject/pages/pricing.dart';

import 'features.dart';
import 'home_page.dart';

class ReferencesPage extends StatefulWidget {
  @override
  _ReferencesPageState createState() => _ReferencesPageState();
}

class _ReferencesPageState extends State<ReferencesPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    // Animasyon Kontrolcüsü
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Animasyonun süresi
      vsync: this,
    );

    // SlideTransition için Offset Animasyonu
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Başlangıç noktası (aşağıdan yukarıya)
      end: Offset.zero, // Son nokta (yerinde sabit)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Yumuşak geçiş
    ));

    // Animasyonu başlatıyoruz
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromRGBO(0, 122, 255, 1), Color.fromRGBO(155, 89, 182, 1)],
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PricingPage()),
                  );
                },
                child: Text(
                  "Fiyatlandırma",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Referanslar sayfasına yönlendir (bu sayfa)
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
            colors: [Color.fromRGBO(0, 122, 255, 1), Color.fromRGBO(155, 89, 182, 1)],
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
                "Referanslarımız",
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
                    SlideTransition(
                      position: _offsetAnimation,
                      child: ReferenceCard(
                        name: "Restoran A",
                        description: "Türkiye'nin en ünlü restoranlarından biri.",
                        imageUrl: 'https://via.placeholder.com/300x160', // Görselin URL'si
                      ),
                    ),
                    SlideTransition(
                      position: _offsetAnimation,
                      child: ReferenceCard(
                        name: "Kafe B",
                        description: "En çok tercih edilen kafelerden biri.",
                        imageUrl: 'https://via.placeholder.com/300x160', // Görselin URL'si
                      ),
                    ),
                    SlideTransition(
                      position: _offsetAnimation,
                      child: ReferenceCard(
                        name: "Otel C",
                        description: "Müşteri memnuniyeti yüksek otellerden biri.",
                        imageUrl: 'https://via.placeholder.com/300x160', // Görselin URL'si
                      ),
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

class ReferenceCard extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;

  ReferenceCard({
    required this.name,
    required this.description,
    required this.imageUrl,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              name,
              style: TextStyle(
                fontSize: 22,
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
    );
  }
}
