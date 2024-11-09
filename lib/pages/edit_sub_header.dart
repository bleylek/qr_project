import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrproject/models/firebase_fetch_model.dart';
import 'package:qrproject/services/auth_service.dart';
import 'package:qrproject/widgets/add_item_dialog.dart';
import 'package:qrproject/widgets/add_sub_header_dialog.dart';
import 'package:qrproject/widgets/re_order_items.dart';
import 'package:qrproject/widgets/re_order_sub_headers.dart';

class EditSubHeader extends StatefulWidget {
  const EditSubHeader({
    super.key,
    required this.userKey,
    required this.itemName,
    required this.digitalMenuAddress,
    required this.companyName,
    required this.mailAddress,
    required this.phoneNumber,
    required this.menuLanguage,
    required this.menuMoneyCurrency,
  });

  final String userKey;
  final String itemName;
  final String digitalMenuAddress;
  final String companyName;
  final String mailAddress;
  final String phoneNumber;
  final String menuLanguage;
  final String menuMoneyCurrency;

  @override
  State<EditSubHeader> createState() => _EditSubHeader();
}

class _EditSubHeader extends State<EditSubHeader> {
  final List<SubHeader> _subHeaders = [];

  bool isLoading = true;

  // burası ile ilgilendim
  @override
  void initState() {
    print("edit_item initState içerisinde_______________");
    print("userKey: ${widget.userKey}");
    print("itemName: ${widget.itemName}");
    print("digitalMenuAddress: ${widget.digitalMenuAddress}");
    print("companyName: ${widget.companyName}");
    print("mailAddress: ${widget.mailAddress}");
    print("phoneNumber: ${widget.phoneNumber}");
    print("menuLanguage: ${widget.menuLanguage}");
    print("menuMoneyCurrency: ${widget.menuMoneyCurrency}");
    super.initState();
    _loadData();
  }

  void _removeMainHeader(MainHeader mainHeader, List<MainHeader> mainHeaders) async {
    /*
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
    */
  }

  Future<void> _loadData() async {
    final itemsCollection = FirebaseFirestore.instance.collection("Users").doc(widget.userKey).collection("SubHeaders");

    try {
      final querySnapshot = await itemsCollection.get();
      for (var doc in querySnapshot.docs) {
        String docName = doc.id;

        if (docName.split('_').first == widget.itemName) {
          final data = doc.data();

          String subHeaderName = docName.split('_').skip(1).join('_');
          int order = data['order'] ?? 0;
          double price = (data['price'] as num).toDouble();

          _subHeaders.add(
            SubHeader(
              subHeaderName: subHeaderName,
              order: order,
              price: price,
            ),
          );
        }
      }

      _subHeaders.sort((a, b) => a.order.compareTo(b.order));
      /*
      for (Item item in _items) {
        print("____________________item_________________________");
        print("ItemName ${item.itemName}");
        print("order ${item.order}");
        print("disable ${item.disable}");
        print("blur ${item.blur}");
        print("explanation ${item.explanation}");
        print("imageUrl ${item.imageUrl}");
        print("price ${item.price}");
      }
      */
    } catch (e) {
      print("Error fetching documents: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("widget.userKey: ${widget.userKey}");
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('SubHeaderları düzenle'),
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
            child: const Text(
              'Çıkış Yap',
              style: TextStyle(color: Colors.white),
            ),
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
                      itemCount: _subHeaders.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            print("Tıklandı");
                          },
                          child: Card(
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
                                          _subHeaders[index].subHeaderName,
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
                                                  "${_subHeaders[index].subHeaderName}'ı silmek istediğinize emin misiniz?",
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
                                                      //  BURASI DEĞİŞECEK
                                                      /*
                                                      Navigator.of(context).pop();
                                                      _removeMainHeader(_mainHeaders[index], _mainHeaders);
                                                      */
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        _subHeaders[index].price != 0 ? "price: ${_subHeaders[index].price}" : "price is not set",
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
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
            heroTag: "subheaderHeroTag",
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  // aaaaaaaaaaaaaaaaaa
                  return AddSubHeaderDialog(subHeaders: _subHeaders, userId: widget.userKey, itemName: widget.itemName);
                },
              ).then((result) {
                if (result != null) {
                  double newPrice = result['newPrice'];
                  int maxOrder = result['maxOrder'];
                  String newSubHeaderName = result['newSubHeaderName'];

                  setState(() {
                    _subHeaders.add(
                      SubHeader(
                        subHeaderName: newSubHeaderName,
                        order: maxOrder,
                        price: newPrice,
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
            onPressed: () async {
              bool result = await showDialog(
                barrierDismissible: false,
                context: context,
                // burası modify edildi
                builder: (context) => ReOrderSubHeaders(
                  subHeaders: _subHeaders,
                  userId: widget.userKey,
                  itemName: widget.itemName,
                ),
              );

              if (result == true) {
                setState(() {
                  _subHeaders.sort((a, b) => a.order.compareTo(b.order));
                });
              }
            },
            icon: const Icon(Icons.reorder),
            label: const Text("Sırayı Düzenle"),
            backgroundColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}
