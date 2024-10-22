import 'package:flutter/material.dart';

// Şirket sloganını içeren container widget'ı
class CompanySloganContainer extends StatelessWidget {
  const CompanySloganContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Container'ın içeriği için padding ayarlanıyor (her taraftan 16.0 birim boşluk)
      padding: const EdgeInsets.all(16.0),
      width: double.infinity, // Genişlik ekranın tamamını kaplayacak
      decoration: BoxDecoration(
        // Arka plan gradient rengi belirleniyor
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.purpleAccent], // Renk geçişi
          begin: Alignment.topLeft, // Gradient başlangıç noktası
          end: Alignment.bottomRight, // Gradient bitiş noktası
        ),
        borderRadius: BorderRadius.circular(12), // Container köşeleri yuvarlatılıyor
        boxShadow: [
          // Gölge efekti ekleniyor
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Gölge rengi ve saydamlığı
            spreadRadius: 2, // Gölgenin yayılma genişliği
            blurRadius: 5, // Gölgenin bulanıklığı
            offset: const Offset(0, 3), // Gölgenin aşağıya kaydırılması
          ),
        ],
      ),
      // İçerik kısmı
      child: Column(
        // Dikeyde ortalama (içeriği dikey eksende ortalar)
        mainAxisAlignment: MainAxisAlignment.center,
        // Yatayda ortalama (içeriği yatay eksende ortalar)
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Şirketin adı
          const Text(
            "QR Menü",
            style: TextStyle(
              fontSize: 32, // Yazı boyutu büyük
              fontWeight: FontWeight.bold, // Kalın yazı stili
              color: Colors.white, // Yazı rengi beyaz
            ),
          ),
          const SizedBox(height: 8), // Şirket adı ile slogan arasında boşluk

          // Şirketin sloganı
          const Text(
            "Menüde Dijital Devrim: QR ile Kolay Sipariş!", // Slogan metni
            textAlign: TextAlign.center, // Metni ortalıyoruz
            style: TextStyle(
              fontSize: 18, // Yazı boyutu
              fontStyle: FontStyle.italic, // Italik yazı stili
              color: Colors.white70, // Yazı rengi beyazın hafif saydam tonu
            ),
          ),
        ],
      ),
    );
  }
}
