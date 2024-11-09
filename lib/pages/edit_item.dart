// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrproject/models/firebase_fetch_model.dart';
import 'package:qrproject/pages/edit_sub_header.dart';
import 'package:qrproject/services/auth_service.dart';
import 'package:qrproject/widgets/add_item_dialog.dart';
import 'package:qrproject/widgets/re_order_items.dart';

class EditItem extends StatefulWidget {
  const EditItem({
    super.key,
    required this.userKey,
    required this.mainHeaderName,
    required this.digitalMenuAddress,
    required this.companyName,
    required this.mailAddress,
    required this.phoneNumber,
    required this.menuLanguage,
    required this.menuMoneyCurrency,
  });

  final String userKey;
  final String mainHeaderName;
  final String digitalMenuAddress;
  final String companyName;
  final String mailAddress;
  final String phoneNumber;
  final String menuLanguage;
  final String menuMoneyCurrency;

  @override
  State<EditItem> createState() => _EditItem();
}

class _EditItem extends State<EditItem> {
  final List<Item> _items = [];

  bool isLoading = true;

  // burası ile ilgilendim
  @override
  void initState() {
    print("edit_item initState içerisinde_______________");
    print("userKey: ${widget.userKey}");
    print("mainHeaderName: ${widget.mainHeaderName}");
    print("digitalMenuAddress: ${widget.digitalMenuAddress}");
    print("companyName: ${widget.companyName}");
    print("mailAddress: ${widget.mailAddress}");
    print("phoneNumber: ${widget.phoneNumber}");
    print("menuLanguage: ${widget.menuLanguage}");
    print("menuMoneyCurrency: ${widget.menuMoneyCurrency}");
    super.initState();
    _loadData();
  }

  void _removeItem(Item item, List<Item> items) async {
    setState(() {
      isLoading = true;
    });

    try {
      int itemOrder = item.order;

      for (int i = 0; i < items.length; i++) {
        Item currentItem = items[i];

        if (currentItem.order > itemOrder) {
          currentItem.order -= 1;
          FirebaseFirestore.instance.collection('Users').doc(widget.userKey).collection("Items").doc(currentItem.docId).update({'order': currentItem.order});
        }

        if (currentItem.itemName == item.itemName) {
          items.removeAt(i);
          i--;
        }
      }

      await FirebaseFirestore.instance.collection('Users').doc(widget.userKey).collection("Items").doc("${widget.mainHeaderName}_${item.itemName}").delete();

      final subHeadersSnapshot = await FirebaseFirestore.instance.collection('Users').doc(widget.userKey).collection("SubHeaders").get();
      for (var doc in subHeadersSnapshot.docs) {
        final docId = doc.id; // itemName_subHeaderName
        final underscoreIndex = docId.indexOf("_");

        // itemName
        final String beforeUnderscore = docId.substring(0, underscoreIndex);

        // subHeaderName
        final String afterUnderscore = docId.substring(underscoreIndex + 1);

        if (underscoreIndex != -1) {
          if (beforeUnderscore == item.itemName) {
            await FirebaseFirestore.instance.collection('Users').doc(widget.userKey).collection("SubHeaders").doc(docId).delete();
          }
        }
      }
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
    final itemsCollection = FirebaseFirestore.instance.collection("Users").doc(widget.userKey).collection("Items");

    try {
      final querySnapshot = await itemsCollection.get();
      for (var doc in querySnapshot.docs) {
        String docName = doc.id;

        if (docName.split('_').first == widget.mainHeaderName) {
          final data = doc.data();

          String itemName = docName.split('_').skip(1).join('_');
          int order = data['order'] ?? 0;
          String imageUrl = data['imageUrl'] ?? "";
          double price = (data['price'] as num).toDouble();
          bool disable = data['disable'] ?? false;
          bool blur = data['blur'] ?? false;
          String explanation = data['explanation'] ?? "";

          _items.add(
            Item(
              itemName: itemName,
              order: order,
              disable: disable,
              blur: blur,
              explanation: explanation,
              imageUrl: imageUrl,
              price: price,
              docId: "${widget.mainHeaderName}_$itemName",
            ),
          );
        }
      }

      _items.sort((a, b) => a.order.compareTo(b.order));
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
        title: const Text('Itemları düzenle'),
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
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditSubHeader(
                                        companyName: widget.companyName,
                                        digitalMenuAddress: widget.digitalMenuAddress,
                                        mailAddress: widget.mailAddress,
                                        menuLanguage: widget.menuLanguage,
                                        menuMoneyCurrency: widget.menuMoneyCurrency,
                                        phoneNumber: widget.phoneNumber,
                                        itemName: _items[index].itemName,
                                        userKey: widget.userKey,
                                      )),
                            );
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
                                          _items[index].itemName,
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
                                                  "${_items[index].itemName}'ı silmek istediğinize emin misiniz? Bu ona bağlı itemları da silecektir.",
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
                                                      _removeItem(_items[index], _items);

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
                                      Text(_items[index].explanation.isNotEmpty ? _items[index].explanation : "Açıklama yok"),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        _items[index].price != 0 ? "price: ${_items[index].price}" : "price is not set",
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        _items[index].disable ? Icons.visibility_off : Icons.visibility,
                                        color: _items[index].disable ? Colors.grey : Colors.blueAccent,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _items[index].disable ? "Gizli" : "Görünür",
                                          style: TextStyle(
                                            color: _items[index].disable ? Colors.grey : Colors.blueAccent,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      // yeni eklenen
                                      Icon(
                                        _items[index].blur ? Icons.lightbulb_outlined : Icons.lightbulb_outline,
                                        color: _items[index].blur ? Colors.grey : Colors.blueAccent,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _items[index].blur ? "Blurlu" : "Blursuz",
                                          style: TextStyle(
                                            color: _items[index].blur ? Colors.grey : Colors.blueAccent,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
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
            heroTag: "itemHeroTag",
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  // aaaaaaaaaaaaaaaaaa
                  return AddItemDialog(
                    mainHeaderName: widget.mainHeaderName,
                    items: _items,
                    userId: widget.userKey,
                  );
                },
              ).then((result) {
                if (result != null) {
                  bool disableStatus = result['disableStatus'];
                  bool blurStatus = result['blurStatus'];
                  double newPrice = result['newPrice'];
                  int maxOrder = result['maxOrder'];
                  String newItemName = result['newItemName'];
                  String newExplanation = result['newExplanation'];

                  setState(() {
                    _items.add(
                      Item(
                        itemName: newItemName,
                        order: maxOrder,
                        disable: disableStatus,
                        blur: blurStatus,
                        explanation: newExplanation,
                        price: newPrice,
                        imageUrl: "",
                        docId: "${widget.mainHeaderName}_$newItemName",
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
                builder: (context) => ReOrderItems(
                  items: _items,
                  userId: widget.userKey,
                  mainHeaderName: widget.mainHeaderName,
                ),
              );

              if (result == true) {
                setState(() {
                  _items.sort((a, b) => a.order.compareTo(b.order));
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
