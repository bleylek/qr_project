import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrproject/models/firebase_fetch_model.dart';

class ReOrderItems extends StatefulWidget {
  const ReOrderItems({
    super.key,
    required this.items,
    required this.userId,
    required this.mainHeaderName,
  });

  final List<Item> items;
  final String userId;
  final String mainHeaderName;

  @override
  State<ReOrderItems> createState() {
    return _ReOrderItems();
  }
}

class _ReOrderItems extends State<ReOrderItems> {
  late List<Item> copyItems = List.from(widget.items);
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    // deep copy yapmamız gerekti burda!
    copyItems = widget.items.map((header) => Item(blur: header.blur, disable: header.disable, explanation: header.explanation, itemName: header.itemName, order: header.order, imageUrl: header.imageUrl, price: header.price, docId: "${header.docId}_${header.itemName}")).toList();
  }

  @override
  void dispose() {
    copyItems.clear();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true; // İşlem başladığında yükleniyor göstergesi
    });

    try {
      for (Item realItem in widget.items) {
        Item copyItem = copyItems.firstWhere(
          (header) => header.itemName == realItem.itemName,
        );

        if (realItem.order != copyItem.order) {
          realItem.order = copyItem.order;

          // Firebase güncellemesi
          try {
            await FirebaseFirestore.instance.collection('Users').doc(widget.userId).collection("Items").doc("${widget.mainHeaderName}_${realItem.itemName}").update({'order': copyItem.order});
          } catch (e) {
            print("Error updating order for ${realItem.itemName}: $e");
            // Hata durumunda kullanıcıya bildirim yapılabilir
          }
        }
      }
    } finally {
      setState(() {
        _isLoading = false; // İşlem tamamlandığında yükleniyor göstergesi gizlenir
      });
      Navigator.of(context).pop(true); // Dialog kapatılır
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        "Sıralamayı düzenle",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: _isLoading // Eğer işlem devam ediyorsa ProgressIndicator'u göster
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: copyItems.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        // Yukarı Butonu
                        IconButton(
                          icon: const Icon(Icons.arrow_upward),
                          onPressed: index == 0
                              ? null
                              : () {
                                  setState(() {
                                    copyItems[index - 1].order++;
                                    copyItems[index].order--;
                                    copyItems.sort((a, b) => a.order.compareTo(b.order));
                                  });
                                },
                        ),
                        // Aşağı Butonu
                        IconButton(
                          icon: const Icon(Icons.arrow_downward),
                          onPressed: index == copyItems.length - 1
                              ? null
                              : () {
                                  setState(() {
                                    copyItems[index + 1].order--;
                                    copyItems[index].order++;
                                    copyItems.sort((a, b) => a.order.compareTo(b.order));
                                  });
                                },
                        ),
                        // MainHeader Adı
                        Text(
                          copyItems[index].itemName,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text("İptal"),
        ),
        TextButton(
          onPressed: _saveChanges, // Değişiklikleri kaydetmek için çağrı
          child: const Text("Değişiklikleri kaydet"),
        ),
      ],
    );
  }
}
