import 'package:flutter/material.dart';
import 'package:qrproject/pages/anasayfa/home_page.dart';
import 'package:qrproject/pages/ozellikler/features.dart';
import 'package:qrproject/pages/referanslar/references.dart';
import 'package:qrproject/widgets/footer.dart';

import '../login_signup.dart'; // Footer widget'ı

class PricingPage extends StatelessWidget {
  const PricingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
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
                        const HomePage()), // Ana Sayfa'ya yönlendir
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
                        const FeaturesPage()), // Özellikler'e yönlendir
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
                    MaterialPageRoute(
                      builder: (context) => ReferencesPage(),
                    ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AuthPage()),
                  );
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AuthPage()),
                  );
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
          ),
        ),
      ),
      body: Column(
        children: [
          // Fiyatlandırma başlığı ve kartlar
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
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
                    const Text(
                      "Fiyatlandırma Planlarımız",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32, // Daha büyük font
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24), // Daha fazla boşluk
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2, // 2 kolonlu grid görünümü
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        children: const [
                          PricingCard(
                            imagePath: 'lib/images/pexels-igor-starkov-233202-1307698.jpg',
                            title: "6 Aylık Plan",
                            price: "660 ₺",
                            description: "6 ay boyunca tüm özellikler ve sınırsız erişim.",
                          ),
                          PricingCard(
                            imagePath: 'lib/images/pexels-viktoria-alipatova-1083711-2074130.jpg',
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
          ),
          // Footer widget'ı, boşluk olmaması için Expanded'in dışında
          const Footer(), // Footer sayfanın en altına sıkıca yapışacak
        ],
      ),
    );
  }
}

class PricingCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final String description;

  const PricingCard({
    super.key,
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
      elevation: 8, // Gölgeyi artırıyoruz
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12), // Resme yuvarlak köşeler ekliyoruz
              child: Image.asset(
                imagePath,
                height: 300, // Daha küçük resim boyutu
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24, // Daha büyük başlık
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              price,
              style: const TextStyle(
                fontSize: 20, // Fiyatı daha büyük ve belirgin
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AuthPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(
                  "Kayıt Ol",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
