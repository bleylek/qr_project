import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qrproject/pages/anasayfa/home_page.dart';
import 'package:qrproject/pages/fiyatlandirma/pricing.dart';
import 'package:qrproject/pages/referanslar/references.dart';
import 'package:qrproject/widgets/footer.dart';

import '../login_signup.dart';

class FeaturesPage extends StatelessWidget {
  const FeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                child: const Text(
                  "Ana Sayfa",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Özellikler",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PricingPage()),
                  );
                },
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
                        builder: (context) => ReferencesPage()),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 400, // Fotoğrafların bulunduğu alan için sabit yükseklik
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "QR Menünün Özellikleri",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // İki fotoğrafın yan yana görünmesini sağlayan Row
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical, // Dikey kaydırma
                        child: Row(
                          children: [
                            Expanded(
                              child: Image.asset(
                                'lib/images/pexels-chanwalrus-941861.jpg', // Fotoğraf 1
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16), // Fotoğraflar arasında boşluk
                            Expanded(
                              child: Image.asset(
                                'lib/images/pexels-victorfreitas-744780.jpg', // Fotoğraf 2
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16), // Fotoğraflardan sonra boşluk

            // Özellikler kısmı
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  FeatureCard(
                    icon: FontAwesomeIcons.qrcode,
                    title: "Kolay QR Kod",
                    description: "Müşterileriniz menüye hızlı ve kolayca erişebilir.",
                  ),
                  FeatureCard(
                    icon: FontAwesomeIcons.mobileAlt,
                    title: "Mobil Uyumluluk",
                    description: "Tüm cihazlarda kusursuz çalışan mobil uyumlu tasarım.",
                  ),
                  FeatureCard(
                    icon: FontAwesomeIcons.lock,
                    title: "Güvenli Altyapı",
                    description: "Verileriniz SSL ile şifrelenir ve güvenli bir şekilde saklanır.",
                  ),
                  FeatureCard(
                    icon: FontAwesomeIcons.language,
                    title: "İstediğiniz Kadar Dil Seçeneği",
                    description: "Yabancı müşterilerinize kendi dillerinde hizmet sağlayın.",
                  ),
                  FeatureCard(
                    icon: FontAwesomeIcons.cogs,
                    title: "Kullanıcı Dostu Yönetim",
                    description: "Menü ve siparişlerinizi hızlıca düzenleyin ve yönetin.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(), // Footer'ı burada ekliyoruz
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10),
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
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
