import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrproject/models/firebase_fetch_model.dart';
import 'package:flutter/services.dart';

class AddSubHeaderDialog extends StatefulWidget {
  const AddSubHeaderDialog({
    super.key,
    required this.subHeaders,
    required this.userId,
    required this.itemName,
  });

  final List<SubHeader> subHeaders;
  final String userId;
  final String itemName;

  @override
  State<AddSubHeaderDialog> createState() {
    return _AddSubHeaderDialog();
  }
}

class _AddSubHeaderDialog extends State<AddSubHeaderDialog> {
  String _newlyAddedSubHeaderName = "";
  double _newlyAddedPrice = 0;
  final _addingForm = GlobalKey<FormState>();

  void _saveSubHeader() async {
    if (_addingForm.currentState!.validate()) {
      _addingForm.currentState!.save();
      final querySnapshot = await FirebaseFirestore.instance.collection('Users').doc(widget.userId).collection("SubHeaders").get();

      bool isNameUsed = false;
      int maxOrder = 0;

      for (var doc in querySnapshot.docs) {
        final docId = doc.id;
        final orderValue = doc.get('order');

        if (orderValue > maxOrder) {
          maxOrder = orderValue;
        }

        final underscoreIndex = docId.indexOf('_');
        final afterUnderscore = docId.substring(underscoreIndex + 1);

        if (afterUnderscore == _newlyAddedSubHeaderName) {
          isNameUsed = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Bu subHeader ismi kullanımda"),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }

      if (!isNameUsed) {
        Map<String, dynamic> newItem = {
          'order': maxOrder + 1,
          'price': _newlyAddedPrice,
        };

        var sendingAddress = await FirebaseFirestore.instance.collection('Users').doc(widget.userId).collection("SubHeaders").doc("${widget.itemName}_${_newlyAddedSubHeaderName}"); // _newlyAddedmainItemName

        await sendingAddress.set(newItem);

        setState(() {});
        Navigator.of(context).pop({
          "newPrice": _newlyAddedPrice.toDouble(),
          'maxOrder': maxOrder + 1,
          'newSubHeaderName': _newlyAddedSubHeaderName,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        "Yeni SubHeader Ekle",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      content: Form(
        key: _addingForm,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Modern giriş alanı
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Subheader İsmi",
                  labelStyle: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.redAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bu alan boş bırakılamaz';
                  } else {
                    for (SubHeader subHeader in widget.subHeaders) {
                      if (subHeader.subHeaderName == value) {
                        return "Bu subHeader ismi zaten kullanımda";
                      }
                    }
                  }
                  return null;
                },
                onSaved: (value) {
                  _newlyAddedSubHeaderName = value!;
                },
              ),
              const SizedBox(height: 15),

              const SizedBox(height: 15),
              TextFormField(
                controller: TextEditingController(text: "0.00"),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Sadece sayı ve ondalık giriş
                ],
                decoration: InputDecoration(
                  labelText: "Fiyat Bilgisi",
                  labelStyle: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.redAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen bir değer giriniz";
                  }

                  try {
                    final doubleValue = double.parse(value);
                    if (doubleValue < 0) {
                      return "Lütfen 0 veya 0'dan büyük bir sayı giriniz";
                    }
                  } catch (e) {
                    return "Lütfen geçerli bir sayı giriniz";
                  }

                  return null;
                },
                onSaved: (value) {
                  if (value == null || value.isEmpty) {
                    _newlyAddedPrice = 0;
                  } else {
                    _newlyAddedPrice = double.parse(value);
                  }
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    TextEditingController(text: "0.00");
                  }
                },
              ),
              const SizedBox(height: 15),
              // Modern ikon butonu

              // Modern butonlar
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "İptal",
                      style: TextStyle(color: Colors.redAccent, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _saveSubHeader,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Kaydet",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
