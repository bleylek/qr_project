import 'package:flutter/material.dart';
import 'package:qrproject/widgets/appBar.dart';  // Mevcut AppBar widget'ınız
import 'package:qrproject/widgets/footer.dart';  // Mevcut Footer widget'ınız

class ReferencesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // crossAxisCount değerini ekran genişliğine göre dinamik yapıyoruz
    int gridCount = 1; // Varsayılan tek sütun (küçük ekranlar için)
    if (screenWidth >= 600) {
      gridCount = 2; // Orta boyutlu ekranlar için iki sütun
    }
    if (screenWidth >= 900) {
      gridCount = 4; // Büyük ekranlar için dört sütun
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // AppBar yüksekliği
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
              SizedBox(height: 40), // Üst boşluk
              Text(
                'Bizi Müşterilerimizden Dinleyin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth < 600 ? 22 : 28, // Ekran boyutuna göre font
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '300\'den fazla işletme ve her gün binlerce kullanıcı QR Menu ile hem işlerini büyütüp hem de müşterilerine hızlı, teknolojik ve kullanışlı bir deneyim yaşatıyor',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: screenWidth < 600 ? 14 : 16, // Ekran boyutuna göre font
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: gridCount, // Dinamik sütun sayısı
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    TestimonialCard(
                      name: "Ahmet Erken",
                      company: "Bodrum Cafe - Adana",
                      review:
                      "QR Menü, müşteri memnuniyetini artırmak için gerçekten mükemmel bir çözümdür...",
                      stars: 5,
                    ),
                    TestimonialCard(
                      name: "Aysun Yılmaz",
                      company: "MADO - Gaziantep",
                      review:
                      "COVID öncesinde, misafirlerimize basılı menü kartları sunuyorduk...",
                      stars: 5,
                    ),
                    TestimonialCard(
                      name: "Jay Carlo Rivera",
                      company: "GODIVA Çikolatacı - Istanbul",
                      review:
                      "QR Menu, kafe satışlarımızı önemli ölçüde artırdı ve özellikle kahvaltı menümüzü başlatmamıza büyük katkı sağladı...",
                      stars: 5,
                    ),
                    TestimonialCard(
                      name: "Mehmet Kalender",
                      company: "Alaçatı Hoteli - Izmir",
                      review:
                      "QR Menü, bizi birçok masraftan kurtardı ve işletmemizin operasyonlarını daha verimli hale getirdi...",
                      stars: 5,
                    ),
                    TestimonialCard(
                      name: "Ahmet Erken",
                      company: "Bodrum Cafe - Adana",
                      review:
                      "QR Menü, müşteri memnuniyetini artırmak için gerçekten mükemmel bir çözümdür...",
                      stars: 5,
                    ),
                    TestimonialCard(
                      name: "Aysun Yılmaz",
                      company: "MADO - Gaziantep",
                      review:
                      "COVID öncesinde, misafirlerimize basılı menü kartları sunuyorduk...",
                      stars: 5,
                    ),
                    TestimonialCard(
                      name: "Jay Carlo Rivera",
                      company: "GODIVA Çikolatacı - Istanbul",
                      review:
                      "QR Menu, kafe satışlarımızı önemli ölçüde artırdı ve özellikle kahvaltı menümüzü başlatmamıza büyük katkı sağladı...",
                      stars: 5,
                    ),
                    TestimonialCard(
                      name: "Mehmet Kalender",
                      company: "Alaçatı Hoteli - Izmir",
                      review:
                      "QR Menü, bizi birçok masraftan kurtardı ve işletmemizin operasyonlarını daha verimli hale getirdi...",
                      stars: 5,
                    ),
                    TestimonialCard(
                      name: "Ahmet Erken",
                      company: "Bodrum Cafe - Adana",
                      review:
                      "QR Menü, müşteri memnuniyetini artırmak için gerçekten mükemmel bir çözümdür...",
                      stars: 5,
                    ),
                    TestimonialCard(
                      name: "Aysun Yılmaz",
                      company: "MADO - Gaziantep",
                      review:
                      "COVID öncesinde, misafirlerimize basılı menü kartları sunuyorduk...",
                      stars: 5,
                    ),
                    TestimonialCard(
                      name: "Jay Carlo Rivera",
                      company: "GODIVA Çikolatacı - Istanbul",
                      review:
                      "QR Menu, kafe satışlarımızı önemli ölçüde artırdı ve özellikle kahvaltı menümüzü başlatmamıza büyük katkı sağladı...",
                      stars: 5,
                    ),
                    TestimonialCard(
                      name: "Mehmet Kalender",
                      company: "Alaçatı Hoteli - Izmir",
                      review:
                      "QR Menü, bizi birçok masraftan kurtardı ve işletmemizin operasyonlarını daha verimli hale getirdi...",
                      stars: 5,
                    ),
                    TestimonialCard(
                      name: "Ahmet Erken",
                      company: "Bodrum Cafe - Adana",
                      review:
                      "QR Menü, müşteri memnuniyetini artırmak için gerçekten mükemmel bir çözümdür...",
                      stars: 5,
                    ),
                    TestimonialCard(
                      name: "Aysun Yılmaz",
                      company: "MADO - Gaziantep",
                      review:
                      "COVID öncesinde, misafirlerimize basılı menü kartları sunuyorduk...",
                      stars: 5,
                    ),
                    TestimonialCard(
                      name: "Jay Carlo Rivera",
                      company: "GODIVA Çikolatacı - Istanbul",
                      review:
                      "QR Menu, kafe satışlarımızı önemli ölçüde artırdı ve özellikle kahvaltı menümüzü başlatmamıza büyük katkı sağladı...",
                      stars: 5,
                    ),
                    TestimonialCard(
                      name: "Mehmet Kalender",
                      company: "Alaçatı Hoteli - Izmir",
                      review:
                      "QR Menü, bizi birçok masraftan kurtardı ve işletmemizin operasyonlarını daha verimli hale getirdi...",
                      stars: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Footer(),  // Mevcut Footer widget'ınızı ekliyoruz
    );
  }
}

class TestimonialCard extends StatelessWidget {
  final String name;
  final String company;
  final String review;
  final int stars;

  const TestimonialCard({
    required this.name,
    required this.company,
    required this.review,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(stars, (index) {
              return Icon(Icons.star, color: Colors.yellow, size: 24);
            }),
          ),
          SizedBox(height: 8),
          Text(
            review,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth < 600 ? 12 : 14, // Ekrana göre font boyutu
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 16),
          Text(
            name,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (company.isNotEmpty)
            Text(
              company,
              style: TextStyle(
                color: Colors.white70,
                fontSize: screenWidth < 600 ? 10 : 12, // Ekrana göre font boyutu
              ),
            ),
        ],
      ),
    );
  }
}
