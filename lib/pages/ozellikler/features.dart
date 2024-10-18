import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qrproject/widgets/appBar.dart';

class FeaturesPage extends StatelessWidget {
  const FeaturesPage({super.key});

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
          child: const Appbar(
            currentPage: "features_page",
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                "Uygulamamızın Temel Özellikleri",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(44, 0, 0, 0),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.2), // Gölge rengi ve opaklığı
                            spreadRadius: 5, // Gölgenin yayılma miktarı
                            blurRadius: 10, // Gölgenin bulanıklık miktarı
                            offset: const Offset(4,
                                4), // Gölgenin x ve y yönlerinde kaydırılması
                          ),
                        ],
                      ),
                    ),

/*
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
                    */
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

  const FeatureCard(
      {required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
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
