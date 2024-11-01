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
  String _userId = "";
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

  void _removeMainHeader(MainHeader mainHeader, List<MainHeader> mainHeaders) async {
    setState(() {
      isLoading = true;
    });

    try {
      int mainHeaderOrder = mainHeader.order;

      for (int i = 0; i < mainHeaders.length; i++) {
        MainHeader currentMainHeader = mainHeaders[i];

        if (currentMainHeader.order > mainHeaderOrder) {
          currentMainHeader.order -= 1;
          FirebaseFirestore.instance.collection('Users').doc(_userId).collection("MainHeaders").doc(currentMainHeader.mainHeaderName).update({'order': currentMainHeader.order});
        }

        if (currentMainHeader.mainHeaderName == mainHeader.mainHeaderName) {
          mainHeaders.removeAt(i);
          i--;
        }
      }

      await FirebaseFirestore.instance.collection('Users').doc(_userId).collection("MainHeaders").doc(mainHeader.mainHeaderName).delete();

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${mainHeader.mainHeaderName} başarıyla silindi')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
          _userId = "${_digitalMenuAddress}_${widget.userKey}";
        }
      }
    }

    final usersCollection = FirebaseFirestore.instance.collection('Users').doc(_userId);

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
        title: const Text('Ana Başlıkları Düzenle'),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Çıkış Yap', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Row(
        children: [
          // Sol tarafta ana başlıklar için alan
          Expanded(
            flex: 2, // Sol tarafın genişliğini ayarlamak için
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, // Tek sütunlu grid
                        mainAxisSpacing: 16, // Yatay boşluk
                        childAspectRatio: 3, // Kartın yüksekliği
                      ),
                      itemCount: _mainHeaders.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _mainHeaders[index].mainHeaderName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close, color: Colors.redAccent),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Onayla'),
                                              content: Text(
                                                "${_mainHeaders[index].mainHeaderName}'ı silmek istediğinize emin misiniz? Bu ona bağlı itemları da silecektir.",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('İptal'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    _removeMainHeader(_mainHeaders[index], _mainHeaders);
                                                    setState(() {});
                                                  },
                                                  child: const Text('Devam et'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    Icon(
                                      _mainHeaders[index].disable ? Icons.visibility : Icons.visibility_off,
                                      color: _mainHeaders[index].disable ? Colors.blueAccent : Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _mainHeaders[index].disable ? "Görünür" : "Gizli",
                                        style: TextStyle(
                                          color: _mainHeaders[index].disable ? Colors.blueAccent : Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Sağ tarafta telefon görseli için alan
          Expanded(
            flex: 1, // Sağ tarafın genişliğini ayarlamak için
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/phone_mockup.png', // Görselin yolu (assets klasörünüzde olmalı)
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AddMainHeaderDialog(
                    mainHeaders: _mainHeaders,
                    userId: _userId,
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
            icon: const Icon(Icons.add),
            label: const Text("Yeni Ekle"),
            backgroundColor: Colors.blueAccent,
          ),
          const SizedBox(width: 16),
          FloatingActionButton.extended(
            onPressed: () {},
            icon: const Icon(Icons.reorder),
            label: const Text("Sırayı Düzenle"),
            backgroundColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}
