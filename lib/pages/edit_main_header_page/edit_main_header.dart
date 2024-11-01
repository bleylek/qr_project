import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrproject/models/firebase_fetch_model.dart';
import 'package:qrproject/services/auth_service.dart';
import 'package:qrproject/widgets/add_main_header_dialog.dart';

class EditMainHeader extends StatefulWidget {
  const EditMainHeader({super.key, required this.userKey});

  final String userKey;

  @override
  State<EditMainHeader> createState() => _EditMainHeaderState();
}

class _EditMainHeaderState extends State<EditMainHeader> {
  final List<MainHeader> _mainHeaders = [];
  String _digitalMenuAddress = "";
  String _userdId = "";
  String _companyName = "";
  String _mailAddress = "";
  String _phoneNumber = "";
  String _menuLanguage = "";
  String _menuMoneyCurrency = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('Users').get();
    for (var doc in querySnapshot.docs) {
      final docId = doc.id;
      final underscoreIndex = docId.indexOf('_');

      if (underscoreIndex != -1) {
        final afterUnderscore = docId.substring(underscoreIndex + 1);
        if (afterUnderscore == widget.userKey) {
          _digitalMenuAddress = docId.substring(0, underscoreIndex);
          _userdId = "${_digitalMenuAddress}_${widget.userKey}";
        }
      }
    }

    final usersCollection = FirebaseFirestore.instance.collection('Users').doc(_userdId);

    try {
      final docSnapshot = await usersCollection.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        _companyName = data?['CompanyName'] ?? "";
        _mailAddress = data?['MailAddress'] ?? "";
        _phoneNumber = data?['PhoneNumber'] ?? "";
        _menuLanguage = data?['MenuLanguage'] ?? "";
        _menuMoneyCurrency = data?['MenuMoneyCurrency'] ?? "";

        final mainHeadersCollection = usersCollection.collection("MainHeaders");
        final mainHeadersSnapshot = await mainHeadersCollection.get();

        for (var doc in mainHeadersSnapshot.docs) {
          final data = doc.data();
          bool disable = data['disable'] ?? false;
          String imageUrl = data['imageUrl'] ?? "";
          int order = data['order'] ?? 0;

          _mainHeaders.add(
            MainHeader(
              mainHeaderName: doc.id,
              order: order,
              disable: disable,
              imageUrl: imageUrl,
            ),
          );
        }
      } else {
        print("Belirtilen kullanıcı bulunamadı.");
      }
    } catch (e) {
      print("Firebase'den veri alınırken hata oluştu: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blueAccent,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Menü Düzenle', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await AuthService().signout();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/auth');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _mainHeaders.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      title: Text(
                        _mainHeaders[index].mainHeaderName,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      trailing: Icon(
                        _mainHeaders[index].disable ? Icons.visibility : Icons.visibility_off,
                        color: _mainHeaders[index].disable ? Colors.green : Colors.redAccent,
                      ),
                      onTap: () {
                        // Your onTap function here
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AddMainHeaderDialog(
                      mainHeaders: _mainHeaders,
                      userId: _userdId,
                    );
                  },
                ).then((result) {
                  if (result != null) {
                    bool disableStatus = result['disableStatus'];
                    int maxOrder = result['maxOrder'];
                    String newMainHeaderName = result['newMainHeaderName'];

                    setState(() {
                      _mainHeaders.add(
                        MainHeader(
                          mainHeaderName: newMainHeaderName,
                          order: maxOrder,
                          disable: disableStatus,
                          imageUrl: "",
                        ),
                      );
                    });
                  }
                });
              },
              icon: Icon(Icons.add),
              label: Text(
                "Yeni Ana Başlık Ekle",
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                // Sırayı düzenle fonksiyonu burada olabilir.
              },
              icon: Icon(Icons.reorder),
              label: Text(
                "Sırayı Düzenle",
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
