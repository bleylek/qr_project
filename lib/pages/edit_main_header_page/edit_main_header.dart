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
    // ilk önce userKey'e bağlı digitalMenuAddress'i almamız gerekiyor

    // Users koleksiyonundaki tüm belgeleri getiriyoruz
    final querySnapshot = await FirebaseFirestore.instance.collection('Users').get();

    // Belgeler arasında gezinerek userId'yi kontrol ediyoruz
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
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Çıkış Yap'),
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            onPressed: () async {
              await AuthService().signout();
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _mainHeaders.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text(_mainHeaders[index].mainHeaderName),
                          const SizedBox(
                            width: 15,
                          ),
                          Icon(
                            _mainHeaders[index].disable ? Icons.visibility : Icons.visibility_off,
                            color: _mainHeaders[index].disable ? Colors.blue : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
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
            child: const Text(
              "Yeni main header ekle",
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text(
              "Sırayı düzenle",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
