import 'package:flutter/material.dart';
import 'package:qrproject/pages/edit_menu_page/edit_menu_page.dart';
import 'package:qrproject/pages/initialization_page/initialization_page.dart';
import 'package:qrproject/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginFirstPage extends StatefulWidget {
  const LoginFirstPage({super.key});

  @override
  State<LoginFirstPage> createState() => _LoginFirstPage();
}

class _LoginFirstPage extends State<LoginFirstPage> {
  Future<bool> userExists(String userId) async {
    // Kullanıcı ID'sinin Users koleksiyonunda mevcut olup olmadığını kontrol et
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    // Eğer belge varsa true, yoksa false döndür
    return querySnapshot.exists;
  }

  @override
  Widget build(BuildContext context) {
    // Oturum açmış kullanıcıyı al
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Çıkış Yap'),
        automaticallyImplyLeading: false, // Geri butonunu gizle
        actions: [
          ElevatedButton(
            onPressed: () async {
              await AuthService().signout();
              // Çıkış yaptıktan sonra giriş sayfasına yönlendir
              // burayı değiştir --> anasayfaya yönlendir
              // mounted kontrolü
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/auth');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child:
                const Text('Çıkış Yap', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: FutureBuilder<bool>(
        future: userExists(user!.uid), // Kullanıcı var mı kontrolü
        builder: (context, snapshot) {
          // firestore'a istek attık, in progress'de
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
            // request'den hata aldık
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata oluştu: ${snapshot.error}"));
            // hata da almadık in progress'de de değiliz
          } else {
            // Kullanıcı var mı kontrolü
            if (snapshot.data == true) {
              return const EditMenuPage(); // Kullanıcı mevcut
            } else {
              return InitializationPage(
                userKey: user.uid,
              ); // Kullanıcı mevcut değil
            }
          }
        },
      ),
    );
  }
}
