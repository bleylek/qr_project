import 'package:flutter/material.dart';

class PricingContainer extends StatelessWidget {
  const PricingContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(200, 255, 255, 255),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Dikey ortalama için
        crossAxisAlignment: CrossAxisAlignment.center, // Yatay ortalama için
        children: [
          const Text(
            'Fiyatlandırma',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPricingCard(
                planDuration: '6 Aylık Plan',
                price: '660 ₺',
              ),
              _buildPricingCard(
                planDuration: '12 Aylık Plan',
                price: '1200 ₺',
              ),
            ],
          ),
          const SizedBox(height: 30),
          _buildFeaturesSection(),
        ],
      ),
    );
  }

  Widget _buildPricingCard(
      {required String planDuration, required String price}) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.green,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            planDuration,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            price,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center, // Dikey ortalama için eklendi
      crossAxisAlignment:
          CrossAxisAlignment.center, // Yatay ortalama için eklendi
      children: [
        const SizedBox(height: 10),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment
              .center, // Her iki sütunu ortalamak için düzenlendi
          children: [
            // Sol sütun
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Sütun ortalanacak
                children: [
                  _buildFeatureItem(
                    title: 'Kullanıcı Dostu Yönetim Paneli',
                    description:
                        'İşlemlerinizi pratik ve hızlı bir şekilde yönetin.',
                  ),
                  _buildFeatureItem(
                    title: '1000+ Ürün ve Kategori Ekleme',
                    description:
                        'Menünüzü dilediğiniz kadar ürün ve kategoriyle zenginleştirin.',
                  ),
                  _buildFeatureItem(
                    title: 'Anında Güncelleme Kolaylığı',
                    description:
                        'Ürün ve fiyat değişikliklerini saniyeler içinde yapın.',
                  ),
                  _buildFeatureItem(
                    title: 'Ürün ve Kategoriler İçin Görsel Yükleme',
                    description:
                        'Menünüzü göz alıcı görsellerle daha çekici hale getirin.',
                  ),
                ],
              ),
            ),
            SizedBox(width: 20), // İki sütun arasında boşluk
            // Sağ sütun
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Sütun ortalanacak
                children: [
                  _buildFeatureItem(
                    title: 'Çeşitli Tema Seçenekleri',
                    description:
                        'Menünüzü farklı temalarla özelleştirerek tarzınızı yansıtın.',
                  ),
                  _buildFeatureItem(
                    title: 'Basıma Hazır QR Kod',
                    description:
                        'QR kodunuzu anında oluşturun ve dilediğiniz yerde kullanın.',
                  ),
                  _buildFeatureItem(
                    title: 'Otomatik Çeviri Desteği',
                    description:
                        'Farklı dillerde hizmet verin, global müşterilerinize kolayca ulaşın.',
                  ),
                  _buildFeatureItem(
                    title: 'Filtreleme Özelliği',
                    description:
                        'Ürünlerinize filtre ekleyerek müşterilerinizin arama işlemlerini kolaylaştırın.',
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 15,
                offset: const Offset(3, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'QR Menünü Hemen Oluştur!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      color: Colors.black26,
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '14 gün ücretsiz deneme ile hemen kullanmaya başla.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Kaydol butonuna basıldığında yapılacak işlem
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.orangeAccent,
                  shadowColor: Colors.black.withOpacity(0.3),
                  elevation: 8,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.login, size: 24, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Kayıt Ol',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _buildFeatureItem extends StatelessWidget {
  final String title;
  final String description;

  const _buildFeatureItem({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
