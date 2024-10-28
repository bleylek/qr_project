import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrproject/models/firebase_fetch_model.dart';
import 'package:qrproject/services/auth_service.dart';

class EditMainHeader extends StatefulWidget {
  const EditMainHeader({super.key, required this.userKey});

  final String userKey;

  @override
  State<EditMainHeader> createState() => _EditMainHeaderState();
}

class _EditMainHeaderState extends State<EditMainHeader> {
  final List<MainHeader> mainHeaders = [];

  void _getDocumentFields() async {
    final mainHeadersCollection = FirebaseFirestore.instance.collection('DigitalAddress').doc(widget.userKey).collection("MainHeaders");

    final snapshot = await mainHeadersCollection.get();

    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        final data = doc.data();

        mainHeaders.add(
          MainHeader(
            mainHeaderName: doc.id,
            order: data['order'],
            disable: data['disable'],
            imageUrl: data['imageUrl'],
          ),
        );
      }
      mainHeaders.sort((a, b) => a.order.compareTo(b.order));
    } else {
      // do nothing --> List<MainHeader> mainHeaders = [] will be remained like this
      // mainHeaders.isEmpty ile check edilir
      print("no mainHeader");
    }

    for (var header in mainHeaders) {
      print("Main Header Name: ${header.mainHeaderName}");
      print("Order: ${header.order}");
      print("Disable: ${header.disable}");
      print("Image URL: ${header.imageUrl}");
      print("-----------");
    }

    /*
    if (mainHeaders.isEmpty) {
      print("correct way of checking");
    }
    */
  }

  @override
  void initState() {
    super.initState();
    _getDocumentFields();
  }

  @override
  Widget build(BuildContext context) {
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
            child: const Text('Çıkış Yap', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: const Text("data"),
    );
  }
}
