import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditMenuPage extends StatefulWidget {
  const EditMenuPage({super.key, required this.userKey});

  final String userKey;

  @override
  State<EditMenuPage> createState() => _EditMenuPageState();
}

class _EditMenuPageState extends State<EditMenuPage> {
  String? digitalMenuAddress;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDigitalMenuAddress();
  }

  Future<void> fetchDigitalMenuAddress() async {
    try {
      // Access the Users collection and fetch the DigitalMenuAddress
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userKey)
          .get();

      setState(() {
        digitalMenuAddress = userDoc.get('DigitalMenuAddress');
        isLoading = false; // Data is fetched, so loading can stop
      });
    } catch (e) {
      // Handle any errors
      setState(() {
        isLoading = false; // Even if there's an error, stop loading
      });
      print('Error fetching DigitalMenuAddress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Menu Page'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // Show progress bar while loading
            : digitalMenuAddress != null
                ? Text(
                    'Digital Menu Address: $digitalMenuAddress') // Show fetched address
                : Text('No address found.'), // Fallback if address is null
      ),
    );
  }
}
