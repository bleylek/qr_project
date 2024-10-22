import 'package:flutter/material.dart';
import 'package:qrproject/services/auth_service.dart'; // AuthService sınıfını ekleyin
import 'package:qrproject/widgets/appBar.dart';  // Home.dart'daki AppBar widget'ı
import 'package:qrproject/widgets/footer.dart';  // Home.dart'daki Footer widget'ı

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  // Şifre sıfırlama fonksiyonu
  Future<void> _resetPassword() async {
    try {
      await AuthService().sendPasswordResetEmail(
          _emailController.text); // AuthService üzerinden şifre sıfırlama
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifre sıfırlama e-postası gönderildi!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Uygulamanın üst barı (AppBar)
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // AppBar yüksekliği
        child: Container(
          // AppBar için gradient arka plan rengi
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          // Özel AppBar widget'ını ekliyoruz
          child: const Appbar(currentPage: "forgot_password_page"),
        ),
      ),

      // Arka plan ve sayfa içeriği
      body: Container(
        width: double.infinity, // Genişliği ekranın tamamına yayılıyor
        height: double.infinity, // Yüksekliği ekranın tamamına yayılıyor
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Şifre Sıfırlama',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Şifreyi Sıfırla',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Giriş Yap Sayfasına Dön',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Footer widget'ı
      bottomNavigationBar: const Footer(), // Footer en alta eklendi
    );
  }
}
