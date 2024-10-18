import 'package:flutter/material.dart';
import 'package:qrproject/widgets/appBar.dart';

class ReferencesPage extends StatefulWidget {
  const ReferencesPage({super.key});

  @override
  State<ReferencesPage> createState() => _ReferencesPageState();
}

class _ReferencesPageState extends State<ReferencesPage>
    with TickerProviderStateMixin {
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
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Appbar(currentPage: "references_page"),
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
                "Referanslarımız",
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
                    SlideTransition(
                      position: _offsetAnimation,
                      child: const ReferenceCard(
                        name: "Restoran A",
                        description:
                            "Türkiye'nin en ünlü restoranlarından biri.",
                        imageUrl:
                            'https://via.placeholder.com/300x160', // Görselin URL'si
                      ),
                    ),
                    SlideTransition(
                      position: _offsetAnimation,
                      child: const ReferenceCard(
                        name: "Kafe B",
                        description: "En çok tercih edilen kafelerden biri.",
                        imageUrl:
                            'https://via.placeholder.com/300x160', // Görselin URL'si
                      ),
                    ),
                    SlideTransition(
                      position: _offsetAnimation,
                      child: const ReferenceCard(
                        name: "Otel C",
                        description:
                            "Müşteri memnuniyeti yüksek otellerden biri.",
                        imageUrl:
                            'https://via.placeholder.com/300x160', // Görselin URL'si
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

  const ReferenceCard({
    super.key,
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
      margin: const EdgeInsets.symmetric(vertical: 10),
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
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
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
    );
  }
}
