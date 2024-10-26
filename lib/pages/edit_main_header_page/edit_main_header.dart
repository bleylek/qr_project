import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrproject/models/firebase_fetch_model.dart';

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
    // TODO: implement build
    throw UnimplementedError();
  }
}
