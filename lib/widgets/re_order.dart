import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrproject/models/firebase_fetch_model.dart';

class ReOrder extends StatefulWidget {
  const ReOrder({
    super.key,
    required this.mainHeaders,
    required this.userId,
  });

  final List<MainHeader> mainHeaders;
  final String userId;

  @override
  State<ReOrder> createState() {
    return _ReOrder();
  }
}

class _ReOrder extends State<ReOrder> {
  late List<MainHeader> copyMainHeaders = List.from(widget.mainHeaders);
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    // deep copy yapmamız gerekti burda!
    copyMainHeaders = widget.mainHeaders.map((header) => MainHeader(mainHeaderName: header.mainHeaderName, order: header.order, imageUrl: header.imageUrl, disable: header.disable)).toList();
  }

  @override
  void dispose() {
    copyMainHeaders.clear();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true; // İşlem başladığında yükleniyor göstergesi
    });

    try {
      for (MainHeader realMainHeader in widget.mainHeaders) {
        MainHeader copyHeader = copyMainHeaders.firstWhere(
          (header) => header.mainHeaderName == realMainHeader.mainHeaderName,
        );

        if (realMainHeader.order != copyHeader.order) {
          realMainHeader.order = copyHeader.order;

          // Firebase güncellemesi
          try {
            await FirebaseFirestore.instance.collection('Users').doc(widget.userId).collection("MainHeaders").doc(realMainHeader.mainHeaderName).update({'order': copyHeader.order});
          } catch (e) {
            print("Error updating order for ${realMainHeader.mainHeaderName}: $e");
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
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: copyMainHeaders.length,
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
                                    copyMainHeaders[index - 1].order++;
                                    copyMainHeaders[index].order--;
                                    copyMainHeaders.sort((a, b) => a.order.compareTo(b.order));
                                  });
                                },
                        ),
                        // Aşağı Butonu
                        IconButton(
                          icon: const Icon(Icons.arrow_downward),
                          onPressed: index == copyMainHeaders.length - 1
                              ? null
                              : () {
                                  setState(() {
                                    copyMainHeaders[index + 1].order--;
                                    copyMainHeaders[index].order++;
                                    copyMainHeaders.sort((a, b) => a.order.compareTo(b.order));
                                  });
                                },
                        ),
                        // MainHeader Adı
                        Text(
                          copyMainHeaders[index].mainHeaderName,
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
