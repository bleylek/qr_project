import 'package:flutter/material.dart';
import 'package:qrproject/services/auth_service.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Çıkış Yap'),
        automaticallyImplyLeading: false, // Geri butonunu gizle
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await AuthService().signout();
            // Çıkış yaptıktan sonra giriş sayfasına yönlendir
            Navigator.pushReplacementNamed(context, '/auth');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text('Çıkış Yap', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
