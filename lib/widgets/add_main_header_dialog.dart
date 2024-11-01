import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrproject/models/firebase_fetch_model.dart';

class AddMainHeaderDialog extends StatefulWidget {
  const AddMainHeaderDialog({
    super.key,
    required this.mainHeaders,
    required this.userId,
  });

  final List<MainHeader> mainHeaders;
  final String userId;

  @override
  State<AddMainHeaderDialog> createState() {
    return _AddMainHeaderDialogState();
  }
}

class _AddMainHeaderDialogState extends State<AddMainHeaderDialog> {
  String _newlyAddedmainHeaderName = "";
  final _addingForm = GlobalKey<FormState>();
  final GlobalKey<_IconButtonWidget> iconButtonKey = GlobalKey<_IconButtonWidget>();

  void _saveItem() async {
    if (_addingForm.currentState!.validate()) {
      _addingForm.currentState!.save();
      final querySnapshot = await FirebaseFirestore.instance.collection('Users').doc(widget.userId).collection("MainHeaders").get();

      bool isNameUsed = false;
      int maxOrder = 0;

      for (var doc in querySnapshot.docs) {
        final docId = doc.id;
        final orderValue = doc.get('order');

        if (orderValue > maxOrder) {
          maxOrder = orderValue;
        }
        if (docId == _newlyAddedmainHeaderName) {
          isNameUsed = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Bu mainHeader ismi kullanımda"),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }

      if (!isNameUsed) {
        Map<String, dynamic> newMainHeader = {
          'disable': iconButtonKey.currentState?.disableStatus ?? true,
          'order': maxOrder + 1,
        };

        var sendingAddress = await FirebaseFirestore.instance.collection('Users').doc(widget.userId).collection("MainHeaders").doc(_newlyAddedmainHeaderName);

        await sendingAddress.set(newMainHeader);

        setState(() {});
        Navigator.of(context).pop({
          'disableStatus': iconButtonKey.currentState?.disableStatus,
          'maxOrder': maxOrder + 1,
          'newMainHeaderName': _newlyAddedmainHeaderName,
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
        "Yeni Ana Başlık Ekle",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: Form(
        key: _addingForm,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Ana Başlık İsmi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bu alan boş bırakılamaz';
                  } else {
                    for (MainHeader mainHeader in widget.mainHeaders) {
                      if (mainHeader.mainHeaderName == value) {
                        return "Bu Ana Başlık ismi zaten kullanımda";
                      }
                    }
                  }
                  return null;
                },
                onSaved: (value) {
                  _newlyAddedmainHeaderName = value!;
                },
              ),
              const SizedBox(height: 15),
              IconButtonWidget(key: iconButtonKey),
              const SizedBox(height: 20),
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Kaydet",
                      style: TextStyle(fontSize: 16),
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

class IconButtonWidget extends StatefulWidget {
  const IconButtonWidget({super.key});

  @override
  State<IconButtonWidget> createState() {
    return _IconButtonWidget();
  }
}

class _IconButtonWidget extends State<IconButtonWidget> {
  bool disable = true;
  bool get disableStatus => disable;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        disable ? Icons.visibility : Icons.visibility_off,
        color: disable ? Colors.blue : Colors.grey,
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
