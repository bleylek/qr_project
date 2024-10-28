import 'package:flutter/material.dart';
import 'package:qrproject/pages/edit_main_header_page/edit_main_header.dart';
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
    final querySnapshot = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    // Eğer belge varsa true, yoksa false döndür
    return querySnapshot.exists;
  }

  @override
  Widget build(BuildContext context) {
    // Oturum açmış kullanıcıyı al
    final user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<bool>(
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
            // BUNU EKLEDİM -SERKAN
            return EditMainHeader(
              userKey: user.uid,
            ); // Kullanıcı mevcut
          } else {
            return InitializationPage(
              userKey: user.uid,
            ); // Kullanıcı mevcut değil
          }
        }
      },
    );
  }
}
