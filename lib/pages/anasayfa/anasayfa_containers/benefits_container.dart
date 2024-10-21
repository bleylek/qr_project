import 'package:flutter/material.dart';

class BenefitsContainer extends StatelessWidget {
  const BenefitsContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Tüm içerikleri yatayda ortalar
        children: [
          const Text(
            'QR Menü Sisteminin Faydaları',
            textAlign: TextAlign.center, // Yazıyı ortalar
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 50, // Row'lar arasında yatay boşluk
            runSpacing: 20, // Satırlar arasında dikey boşluk
            alignment: WrapAlignment.center, // Wrap içeriğini ortalar
            children: [
              _buildBenefitItem(
                icon: Icons.update,
                title: 'Kolay Güncelleme',
                description:
                    'Tükenen ürünleri ve fiyatları anında değiştirin, menünüz her zaman güncel kalsın!',
              ),
              _buildBenefitItem(
                icon: Icons.clean_hands,
                title: 'Hijyenik Deneyim',
                description:
                    'Fiziksel teması ortadan kaldırarak müşterilere güvenli bir menü deneyimi sunun.',
              ),
              _buildBenefitItem(
                icon: Icons.filter_list,
                title: 'Akıllı Filtreleme',
                description:
                    'Müşteriler, istedikleri özelliklere göre doğru ürünü hızla bulsun.',
              ),
              _buildBenefitItem(
                icon: Icons.language,
                title: 'Çoklu Dil Desteği',
                description:
                    'Yabancı müşterilere kolayca hizmet verin, dil bariyerlerini aşın.',
              ),
              _buildBenefitItem(
                icon: Icons.eco,
                title: 'Çevre Dostu',
                description:
                    'Kağıt kullanımını minimuma indirerek hem maliyetlerinizi düşürün hem de doğaya katkıda bulunun.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(
      {required IconData icon,
      required String title,
      required String description}) {
    return Container(
      width:
          160, // Her bir öğenin genişliğini sabit tutarak sarmalanmalarını sağlıyor
      height: 200, // Kare şeklinde görünüm
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Dikeyde ortalama
        crossAxisAlignment: CrossAxisAlignment.center, // Yatayda ortalama

        children: [
          const SizedBox(
            height: 10,
          ),
          Icon(icon, size: 30, color: Colors.green),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center, // Yazı ortalanır
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
