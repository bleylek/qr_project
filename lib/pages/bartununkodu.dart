import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  File? _selectedImageFile;
  String? _imageUrl;
  final _addingForm = GlobalKey<FormState>();
  final GlobalKey<IconButtonWidgetState> iconButtonKey = GlobalKey<IconButtonWidgetState>();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path); // File olarak saklıyoruz
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Resim seçilmedi."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _uploadImage(String mainHeaderName) async {
    if (_selectedImageFile == null) {
      print("No image selected to upload.");
      return;
    }

    try {
      final storageRef = FirebaseStorage.instance.ref().child('mainHeaders/$mainHeaderName');
      print("Uploading image to path: mainHeaders/$mainHeaderName");
      final bytes = await _selectedImageFile!.readAsBytes();

      // Dosya yükleme işlemi başlatılıyor
      final uploadTask = await storageRef.putData(bytes);

      // Yükleme tamamlandığında sonucunu kontrol edebilirsiniz
      _imageUrl = await uploadTask.ref.getDownloadURL(); // Set _imageUrl here
      print("Image uploaded successfully. Download URL: $_imageUrl");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resim başarıyla yüklendi')),
      );
    } catch (e) {
      print("Error during upload: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resim yükleme hatası: ${e.toString()}')),
      );
    }
  }

  void _saveItem() async {
    if (_addingForm.currentState!.validate()) {
      print("a");
      _addingForm.currentState!.save();
      print("a1");

      await _uploadImage(_newlyAddedmainHeaderName);
      print("a2");

      if (_imageUrl == null || _imageUrl!.isEmpty) {
        print("Error: Image URL is still empty, skipping Firestore update.");
        return;
      }

      try {
        final querySnapshot = await FirebaseFirestore.instance.collection('Users').doc(widget.userId).collection("MainHeaders").get();
        print("a3");

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
              const SnackBar(
                content: Text("Bu ana başlık ismi kullanımda."),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        }

        if (!isNameUsed) {
          Map<String, dynamic> newMainHeader = {
            'disable': iconButtonKey.currentState?.disableStatus ?? true,
            'order': maxOrder + 1,
            'imageUrl': _imageUrl ?? "", // Firestore'a imageUrl ekle
          };

          var sendingAddress = await FirebaseFirestore.instance.collection('Users').doc(widget.userId).collection("MainHeaders").doc(_newlyAddedmainHeaderName);

          await sendingAddress.set(newMainHeader);

          setState(() {});
          Navigator.of(context).pop({
            'disableStatus': iconButtonKey.currentState?.disableStatus,
            'maxOrder': maxOrder + 1,
            'newMainHeaderName': _newlyAddedmainHeaderName,
            'imageUrl': _imageUrl,
          });
        }
      } catch (e) {
        print("Error accessing Firestore: ${e.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Firestore erişim hatası: ${e.toString()}')),
        );
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
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
                  labelStyle: TextStyle(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Görünürlük Ayarı",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  IconButtonWidget(key: iconButtonKey),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Resim Ekle"),
              ),
              if (_selectedImageFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.file(
                    _selectedImageFile!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
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
                        borderRadius: BorderRadius.circular(12),
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

extension on Future<TaskSnapshot> {
  get snapshotEvents => null;
}

class IconButtonWidget extends StatefulWidget {
  const IconButtonWidget({super.key});

  @override
  State<IconButtonWidget> createState() {
    return IconButtonWidgetState();
  }
}

class IconButtonWidgetState extends State<IconButtonWidget> {
  bool disable = true;
  bool get disableStatus => disable;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        disable ? Icons.visibility : Icons.visibility_off,
        color: disable ? Colors.blueAccent : Colors.grey,
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
