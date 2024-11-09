import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrproject/models/firebase_fetch_model.dart';

class ReOrderSubHeaders extends StatefulWidget {
  const ReOrderSubHeaders({
    super.key,
    required this.subHeaders,
    required this.userId,
    required this.itemName,
  });

  final List<SubHeader> subHeaders;
  final String userId;
  final String itemName;

  @override
  State<ReOrderSubHeaders> createState() {
    return _ReOrderSubHeaders();
  }
}

class _ReOrderSubHeaders extends State<ReOrderSubHeaders> {
  late List<SubHeader> copySubHeaders = List.from(widget.subHeaders);
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    // deep copy yapmamız gerekti burda!
    copySubHeaders = widget.subHeaders.map((subHeader) => SubHeader(order: subHeader.order, subHeaderName: subHeader.subHeaderName, price: subHeader.price)).toList();
  }

  @override
  void dispose() {
    copySubHeaders.clear();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true; // İşlem başladığında yükleniyor göstergesi
    });

    try {
      for (SubHeader realSubHeader in widget.subHeaders) {
        SubHeader copySubHeader = copySubHeaders.firstWhere(
          (header) => header.subHeaderName == realSubHeader.subHeaderName,
        );

        if (realSubHeader.order != copySubHeader.order) {
          realSubHeader.order = copySubHeader.order;

          // Firebase güncellemesi
          try {
            await FirebaseFirestore.instance.collection('Users').doc(widget.userId).collection("SubHeaders").doc("${widget.itemName}_${realSubHeader.subHeaderName}").update({'order': copySubHeader.order});
          } catch (e) {
            print("Error updating order for ${realSubHeader.subHeaderName}: $e");
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
                itemCount: copySubHeaders.length,
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
                                    copySubHeaders[index - 1].order++;
                                    copySubHeaders[index].order--;
                                    copySubHeaders.sort((a, b) => a.order.compareTo(b.order));
                                  });
                                },
                        ),
                        // Aşağı Butonu
                        IconButton(
                          icon: const Icon(Icons.arrow_downward),
                          onPressed: index == copySubHeaders.length - 1
                              ? null
                              : () {
                                  setState(() {
                                    copySubHeaders[index + 1].order--;
                                    copySubHeaders[index].order++;
                                    copySubHeaders.sort((a, b) => a.order.compareTo(b.order));
                                  });
                                },
                        ),
                        // MainHeader Adı
                        Text(
                          copySubHeaders[index].subHeaderName,
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
