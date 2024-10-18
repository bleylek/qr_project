import 'package:flutter/material.dart';
import 'package:qrproject/pages/logut.dart';
import 'package:qrproject/services/auth_service.dart';

class SignupPage extends StatefulWidget {
  final PageController pageController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignupPage({
    super.key,
    required this.pageController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purpleAccent, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Kayıt Ol",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: widget.emailController,
              decoration: InputDecoration(
                labelText: "E-posta",
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: widget.passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Şifre",
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Şifreyi Doğrula",
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                if (widget.passwordController.text ==
                    _confirmPasswordController.text) {
                  bool success = await AuthService().signup(
                    email: widget.emailController.text,
                    password: widget.passwordController.text,
                  );

                  if (success) {
                    // Doğrulama kodu oluştur
                    String verificationCode =
                        AuthService().generateVerificationCode();

                    // Kullanıcıyı doğrulama sayfasına yönlendir
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LogoutPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kayıt Başarısız')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Şifreler uyuşmuyor')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Center(
                child: Text("Kayıt Ol", style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  widget.pageController.animateToPage(0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
                child: const Text("Zaten hesabın var mı? Giriş Yap",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
