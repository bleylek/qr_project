import 'package:flutter/material.dart';
import 'package:qrproject/pages/anasayfa/anasayfa_containers/benefits_container.dart';
import 'package:qrproject/pages/anasayfa/anasayfa_containers/menu_images_container.dart';
import 'package:qrproject/pages/anasayfa/anasayfa_containers/pricing_container.dart';
import 'package:qrproject/widgets/appBar.dart';
import 'package:qrproject/widgets/footer.dart';
import 'anasayfa_containers/slogan_container.dart';

// HomePage sınıfı StatelessWidget'ı extends ediyor. Bu sayfa ana sayfa olacak.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ekran genişliği ve yüksekliğini alıyoruz
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Uygulamanın üst barı (AppBar)
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // AppBar yüksekliğini ayarlıyoruz
        child: Container(
          // AppBar için bir gradient arka plan rengi belirleniyor
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          // Özel Appbar widget'ı ekleniyor (appBar.dart dosyasından)
          child: const Appbar(
            currentPage: "home_page", // Şu anki sayfanın "home_page" olduğunu belirtiyoruz
          ),
        ),
      ),
      // Ana sayfa gövdesi (body)
      body: Container(
        width: double.infinity, // Genişliği ekranın tamamına yayılıyor
        height: double.infinity, // Yüksekliği ekranın tamamına yayılıyor
        decoration: const BoxDecoration(
          // Arka plan için gradient renk geçişi
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0), // İsteğe bağlı padding ayarı
          child: ListView(
            // Tüm sayfa içeriklerini ListView içinde sırayla gösteriyoruz
            children: [
              // Şirketin sloganını gösteren container
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02, // Yükseklik oranına göre boşluk
                  horizontal: screenWidth * 0.05, // Genişlik oranına göre boşluk
                ),
                child: const CompanySloganContainer(),
              ),

              // Faydalar (Benefits) container'ı
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02, // Yükseklik oranına göre boşluk
                  horizontal: screenWidth * 0.05, // Genişlik oranına göre boşluk
                ),
                child: const BenefitsContainer(),
              ),

              // Sayfalar arası boşluk
              SizedBox(height: screenHeight * 0.05),

              // Menü resimlerini gösteren container
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02, // Yükseklik oranına göre boşluk
                  horizontal: screenWidth * 0.05, // Genişlik oranına göre boşluk
                ),
                child: const MenuImagesContainer(),
              ),

              // Sayfalar arası boşluk
              SizedBox(height: screenHeight * 0.05),

              // Fiyatlandırma container'ı
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02, // Yükseklik oranına göre boşluk
                  horizontal: screenWidth * 0.05, // Genişlik oranına göre boşluk
                ),
                child: const PricingContainer(),
              ),

              // Sayfalar arası boşluk
              SizedBox(height: screenHeight * 0.05),

              // Footer (alt kısım) widget'ı
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
