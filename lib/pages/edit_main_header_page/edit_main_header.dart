import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qrproject/models/firebase_fetch_model.dart';
import 'package:qrproject/pages/deneme_sayfasi.dart';
import 'package:qrproject/pages/edit_item.dart';
import 'package:qrproject/services/auth_service.dart';
import 'package:qrproject/widgets/add_main_header_dialog.dart';
import 'package:qrproject/widgets/re_order.dart';
import 'package:http/http.dart' as http;

class EditMainHeader extends StatefulWidget {
  // userKey'i alıyoruz burda. Fakat edit_item'a _userId'yi göndereceğiz. Parametre olarak
  const EditMainHeader({
    super.key,
    required this.userKey,
  });

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

  Future<Uint8List?> fetchFileFromUrl(String imageUrl) async {
    try {
      // HTTP GET isteği yap
      final response = await http.get(Uri.parse(imageUrl));

      // Yanıt başarılı ise Uint8List döndür
      if (response.statusCode == 200) {
        return response.bodyBytes; // Dosya verisi Uint8List formatında döner
      } else {
        debugPrint("Failed to fetch file. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching file: $e");
      return null;
    }
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

      // burda senden yapmanı istediğim FirebaseFirestore.instance.collection('Users').doc(_userId).collection("Items").doc(...) koleksiyonunda

      // bağlı itemları sil
      final itemsSnapshot = await FirebaseFirestore.instance.collection('Users').doc(_userId).collection("Items").get();

      List<String> itemNames = [];
      for (var doc in itemsSnapshot.docs) {
        final docId = doc.id;
        final underscoreIndex = docId.indexOf("_");

        // mainHeaderName
        final String beforeUnderscore = docId.substring(0, underscoreIndex);

        // itemName
        final String afterUnderscore = docId.substring(underscoreIndex + 1);

        if (underscoreIndex != -1 && beforeUnderscore == mainHeader.mainHeaderName) {
          itemNames.add(afterUnderscore);
          await FirebaseFirestore.instance.collection('Users').doc(_userId).collection("Items").doc(docId).delete();
        }
      }

      // bağlı subHeaderları sil
      final subHeadersSnapshot = await FirebaseFirestore.instance.collection('Users').doc(_userId).collection("SubHeaders").get();

      for (var doc in subHeadersSnapshot.docs) {
        final docId = doc.id;
        final underscoreIndex = docId.indexOf("_");

        // itemName
        final String beforeUnderscore = docId.substring(0, underscoreIndex);

        // subHeaderName
        final String afterUnderscore = docId.substring(underscoreIndex + 1);

        if (underscoreIndex != -1) {
          if (itemNames.contains(beforeUnderscore)) {
            await FirebaseFirestore.instance.collection('Users').doc(_userId).collection("SubHeaders").doc(docId).delete();
          }
        }
      }
      /*
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
      */

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

          // if it is in web browser
          if (kIsWeb) {
            // if no image to show
            if (imageUrl == " ") {
              _mainHeaders.add(
                MainHeader(
                  mainHeaderName: doc.id,
                  order: order,
                  disable: disable,
                  imageUrl: imageUrl,
                ),
              );
            }
            // if there is image to show
            else {
              //
              Uint8List? currentImage = await fetchFileFromUrl(imageUrl);

              // normalde bu kısımda currentImage'ın null olma ihtimali yok. Fakat firebase bağlantı sorunu olması durumunda ola ki resmi storage'dan çekemezsek diye bu if-else statementını ekledim
              if (currentImage == null) {
                _mainHeaders.add(
                  MainHeader(
                    mainHeaderName: doc.id,
                    order: order,
                    disable: disable,
                    imageUrl: imageUrl,
                  ),
                );
              } else {
                _mainHeaders.add(
                  MainHeader(
                    mainHeaderName: doc.id,
                    order: order,
                    disable: disable,
                    imageUrl: imageUrl,
                    webImage: currentImage,
                  ),
                );
              }
            }
          }
          // if it is mobile
          else {
            //
          }
        }
        _mainHeaders.sort((a, b) => a.order.compareTo(b.order));
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
    print(_userId);
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
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditItem(
                                    userKey: _userId,
                                    mainHeaderName: _mainHeaders[index].mainHeaderName,
                                    companyName: _companyName,
                                    digitalMenuAddress: _digitalMenuAddress,
                                    mailAddress: _mailAddress,
                                    menuLanguage: _menuLanguage,
                                    menuMoneyCurrency: _menuMoneyCurrency,
                                    phoneNumber: _phoneNumber,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  // İçerik
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Sol tarafta resim
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxWidth: 150, // Resim genişliği
                                            maxHeight: 150, // Resim yüksekliği
                                          ),
                                          child: Builder(
                                            builder: (context) {
                                              // in web browser
                                              if (kIsWeb) {
                                                // no image to display
                                                if (_mainHeaders[index].webImage == null) {
                                                  return Container(
                                                    width: 150,
                                                    height: 150,
                                                    color: Colors.grey,
                                                    child: const Icon(Icons.image, color: Colors.white),
                                                  );
                                                }
                                                // image to display
                                                else {
                                                  return Container(
                                                    width: 150,
                                                    height: 150,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey, // Kenarlık rengi
                                                        width: 2.0, // Kenarlık kalınlığı
                                                      ),
                                                      borderRadius: BorderRadius.circular(8), // Kenarlığın köşelerini yuvarlama
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(8), // İçeriğin köşe yuvarlaklığı
                                                      child: Image.memory(
                                                        _mainHeaders[index].webImage!,
                                                        width: 150,
                                                        height: 150,
                                                        fit: BoxFit.contain, // Resmi tam olarak doldur
                                                      ),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                return Text("data");
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 12), // Resim ve metin arası boşluk
                                        // Sağ tarafta metin
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Main Header Name
                                              Padding(
                                                padding: const EdgeInsets.only(right: 40), // Çarpı işareti için boşluk
                                                child: Text(
                                                  _mainHeaders[index].mainHeaderName,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow: TextOverflow.visible,
                                                ),
                                              ),
                                              const SizedBox(height: 8), // Alt metin için boşluk
                                              // Visibility and Status
                                              Row(
                                                children: [
                                                  Icon(
                                                    _mainHeaders[index].disable ? Icons.visibility : Icons.visibility_off,
                                                    color: _mainHeaders[index].disable ? Colors.blueAccent : Colors.grey,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    _mainHeaders[index].disable ? "Görünür" : "Gizli",
                                                    style: TextStyle(
                                                      color: _mainHeaders[index].disable ? Colors.blueAccent : Colors.grey,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Sağ üst köşede çarpı simgesi
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: IconButton(
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
                                  ),
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Sağ tarafta telefon görseli için alan
          const Expanded(
            flex: 1, // Sağ tarafın genişliğini ayarlamak için
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 40,
                )),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "mainHeaderHeroTag",
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
                  // in web browser
                  if (kIsWeb) {
                    print("result['imageUrl']: ${result['imageUrl']}");
                    bool disableStatus = result['disableStatus'];
                    int maxOrder = result['maxOrder'];
                    String newMainHeaderName = result['newMainHeaderName'];
                    Uint8List? newlyAddedWebImage = result['newlyAddedImageWeb'];
                    String imageUrl = result['imageUrl'];

                    setState(() {
                      _mainHeaders.add(
                        MainHeader(
                          mainHeaderName: newMainHeaderName,
                          order: maxOrder,
                          disable: disableStatus,
                          webImage: newlyAddedWebImage,
                          imageUrl: imageUrl,
                        ),
                      );
                    });
                  } else {
                    // eğer mobilde ise
                    /*
                    bool disableStatus = result['disableStatus'];
                    int maxOrder = result['maxOrder'];
                    String newMainHeaderName = result['newMainHeaderName'];
                    File? mobileImage;
                    */
                  }
                }
              });
            },
            icon: const Icon(Icons.add),
            label: const Text("Yeni Ekle"),
            backgroundColor: Colors.blueAccent,
          ),
          const SizedBox(width: 16),
          FloatingActionButton.extended(
            heroTag: "order",
            onPressed: () async {
              bool result = await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => ReOrder(
                  mainHeaders: _mainHeaders,
                  userId: _userId,
                ),
              );

              if (result == true) {
                setState(() {
                  _mainHeaders.sort((a, b) => a.order.compareTo(b.order));
                });
              }
            },
            icon: const Icon(Icons.reorder),
            label: const Text("Sırayı Düzenle"),
            backgroundColor: Colors.blueAccent,
          ),
          FloatingActionButton.extended(
            heroTag: "denemePage",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ImageUploadPage(),
                ),
              );
            },
            icon: const Icon(Icons.train),
            label: const Text("Deneme Sayfası"),
            backgroundColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}
