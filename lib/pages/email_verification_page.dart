import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrproject/pages/logut.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool canResendEmail = false; // E-posta yeniden gönderme durumu
  bool isLoading = false; // Yükleme durumu
  bool isEmailVerified = false; // E-posta doğrulandı mı kontrolü

  @override
  void initState() {
    super.initState();

    // Sayfa yüklendiğinde e-posta doğrulama linki gönderiliyor
    sendVerificationEmail();

    // İlk kontrol: Email doğrulandı mı
    checkEmailVerified();
  }

  // Firebase'de e-postanın doğrulanıp doğrulanmadığını kontrol et
  Future<void> checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload(); // Kullanıcı durumunu yeniden yükle
    setState(() {
      isEmailVerified = user?.emailVerified ?? false;
    });

    if (isEmailVerified) {
      // Eğer e-posta doğrulandıysa LogoutPage'e yönlendirilir
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LogoutPage()),
        );
      });
    }
  }

  // E-posta doğrulama linkini gönder
  Future<void> sendVerificationEmail() async {
    setState(() {
      isLoading = true; // Yükleme göstergesi
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification(); // E-posta doğrulama linkini gönder

        setState(() {
          canResendEmail = false;
        });

        // 5 saniye sonra tekrar göndermeye izin ver
        await Future.delayed(const Duration(seconds: 5));
        setState(() {
          canResendEmail = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Doğrulama linki e-posta ile gönderildi')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false; // Yükleme göstergesini kapat
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-posta Doğrulama'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Size mail olarak bir doğrulama linki gönderdik.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: canResendEmail ? sendVerificationEmail : null, // Yeniden gönderme butonu
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Tekrar Gönder'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: canResendEmail ? Colors.blueAccent : Colors.grey, // Button color
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: checkEmailVerified, // Doğrulama kontrolü
                child: const Text('E-postayı Doğrulayıp Kontrol Et'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Kontrol butonu rengi
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
