import 'package:flutter/material.dart';
import 'package:qrproject/pages/anasayfa/home_page.dart';
import 'package:qrproject/pages/fiyatlandirma/pricing.dart';
import 'package:qrproject/pages/giris_sayfasi/login_page.dart';
import 'package:qrproject/pages/kayit_olma_sayfasi/signup_page.dart';
import 'package:qrproject/pages/referanslar/references.dart';
import '../widgets/footer.dart'; // Footer import

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final PageController _pageController = PageController();

  // TextEditingController'lar
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            automaticallyImplyLeading: false, // Geri butonunu gizlemek için
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: const Text(
                  "Ana Sayfa",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Şu anda özellikler sayfası
                },
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
                  // Giriş sayfasına yönlendir (bu sayfa)
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
                  // Kaydol sayfasına yönlendir
                  _pageController.animateToPage(1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
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
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                LoginPage(pageController: _pageController), // Giriş Yap sayfası
                SignupPage(
                    pageController: _pageController,
                    emailController: _emailController,
                    passwordController: _passwordController), // Kaydol sayfası
              ],
            ),
          ),
          const Footer(), // Footer'ı burada ekliyoruz
        ],
      ),
    );
  }
}
