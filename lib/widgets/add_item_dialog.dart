import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrproject/models/firebase_fetch_model.dart';
import 'package:flutter/services.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({
    super.key,
    required this.items,
    required this.userId,
    required this.mainHeaderName,
  });

  final List<Item> items;
  final String userId;
  final String mainHeaderName;

  @override
  State<AddItemDialog> createState() {
    return _AddItemDialog();
  }
}

class _AddItemDialog extends State<AddItemDialog> {
  String _newlyAddedItemName = "";
  String _newlyAddedExplanation = "";
  double _newlyAddedPrice = 0;
  final _addingForm = GlobalKey<FormState>();
  final GlobalKey<_IconButtonWidget> iconDisableKey = GlobalKey<_IconButtonWidget>();
  final GlobalKey<_BlurButtonWidget> iconBlurKey = GlobalKey<_BlurButtonWidget>();

  void _saveItem() async {
    if (_addingForm.currentState!.validate()) {
      _addingForm.currentState!.save();
      final querySnapshot = await FirebaseFirestore.instance.collection('Users').doc(widget.userId).collection("Items").get();

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

        if (afterUnderscore == _newlyAddedItemName) {
          // _newlyAddedmainItemName
          isNameUsed = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Bu item ismi kullanımda"),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }

      if (!isNameUsed) {
        Map<String, dynamic> newItem = {
          'disable': iconDisableKey.currentState?.disableStatus ?? true,
          'blur': iconBlurKey.currentState?.blurStatus ?? true,
          'order': maxOrder + 1,
          'explanation': _newlyAddedExplanation,
          'price': _newlyAddedPrice,
        };

        var sendingAddress = await FirebaseFirestore.instance.collection('Users').doc(widget.userId).collection("Items").doc("${widget.mainHeaderName}_${_newlyAddedItemName}"); // _newlyAddedmainItemName

        await sendingAddress.set(newItem);

        setState(() {});
        Navigator.of(context).pop({
          'disableStatus': iconDisableKey.currentState?.disableStatus,
          'blurStatus': iconBlurKey.currentState?.blurStatus,
          "newPrice": _newlyAddedPrice.toDouble(),
          'maxOrder': maxOrder + 1,
          'newItemName': _newlyAddedItemName,
          'newExplanation': _newlyAddedExplanation,
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
        "Yeni Item Ekle",
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
                  labelText: "Item İsmi",
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
                    for (Item item in widget.items) {
                      if (item.itemName == value) {
                        return "Bu item ismi zaten kullanımda";
                      }
                    }
                  }
                  return null;
                },
                onSaved: (value) {
                  _newlyAddedItemName = value!;
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                decoration: InputDecoration(
                  labelText: "Açıklama",
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
                  return null;
                },
                onSaved: (value) {
                  if (value == null) {
                    _newlyAddedExplanation = "";
                  } else {
                    _newlyAddedExplanation = value;
                  }
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: TextEditingController(text: "0.00"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Disable Ayarı",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  IconButtonWidget(key: iconDisableKey), // Sağda ikon
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Blur Ayarı",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  BlurButtonWidget(key: iconBlurKey),
                ],
              ),

              const SizedBox(height: 20),
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
                    onPressed: _saveItem,
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

// Göz ikonu için modern widget
class IconButtonWidget extends StatefulWidget {
  const IconButtonWidget({super.key});

  @override
  State<IconButtonWidget> createState() {
    return _IconButtonWidget();
  }
}

class _IconButtonWidget extends State<IconButtonWidget> {
  bool disable = false;
  bool get disableStatus => disable;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        disable ? Icons.visibility_off : Icons.visibility,
        color: disable ? Colors.grey : Colors.blueAccent,
        size: 30,
      ),
      onPressed: () {
        setState(() {
          disable = !disable;
        });
      },
    );
  }
}

// Blur ikonu için modern widget
class BlurButtonWidget extends StatefulWidget {
  const BlurButtonWidget({super.key});

  @override
  State<BlurButtonWidget> createState() {
    return _BlurButtonWidget();
  }
}

class _BlurButtonWidget extends State<BlurButtonWidget> {
  bool blur = false;
  bool get blurStatus => blur;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        blur ? Icons.lightbulb_outlined : Icons.lightbulb_outline,
        color: blur ? Colors.grey : Colors.blueAccent,
        size: 30,
      ),
      onPressed: () {
        setState(() {
          blur = !blur;
        });
      },
    );
  }
}
