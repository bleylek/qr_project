import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
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
  final _addingForm = GlobalKey<FormState>();
  final GlobalKey<_IconButtonWidget> iconButtonKey = GlobalKey<_IconButtonWidget>();

  /* SONRADAN EKLENEN */
  // resimler
  File? _pickedImage; // for mobile
  Uint8List? webImage; // for web
  Uint8List? controlWebImage;

  // Uint8List formatındaki dosyanın byte olarak büyüklüğünü int cinsinden döndürür
  int getFileSize(Uint8List fileData) {
    return fileData.length; // Dosya boyutunu byte olarak döner.
  }

  /* String döndürüyor. Kullanıcı tarafından seçilen dosyanın türüne göre:
  Dosya jpeg veya jpg türünde ise "jpeg"
  png türünde ise "png"
  WebP türünde ise "webp"
  bu 4'ünden hiçbiri değil ise null döndürüyor
 */
  String? detectImageType(Uint8List imageData) {
    if (imageData.isEmpty) return null; // Veri boşsa tespit edilemez.

    // Byte karşılaştırmalarını kolaylaştırmak için.
    const eq = ListEquality();

    // JPEG (ve JPG) kontrolü
    if (imageData.length >= 3 && eq.equals(imageData.sublist(0, 3), [0xFF, 0xD8, 0xFF])) {
      return "jpeg";
    }

    // PNG kontrolü
    if (imageData.length >= 8 && eq.equals(imageData.sublist(0, 8), [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])) {
      return "png";
    }

    // WebP kontrolü
    if (imageData.length >= 12 &&
        eq.equals(imageData.sublist(0, 4), [0x52, 0x49, 0x46, 0x46]) && // 'RIFF'
        eq.equals(imageData.sublist(8, 12), [0x57, 0x45, 0x42, 0x50])) {
      // 'WEBP'
      return "webp";
    }

    // Tür belirlenemedi
    return null;
  }
  /* SONRADAN EKLENEN */

  /*
  final storageRef = customStorage.ref();
          final imageRef = storageRef.child(widget.userId).child('mainHeaders').child('$_newlyAddedmainHeaderName.$imageType');

          final metadata = SettableMetadata(
            contentType: "image/$imageType", // İçerik türünü belirtin
          );

          await imageRef.putData(image, metadata).whenComplete(() {
            debugPrint("File Uploaded...");
          });
   */

  void _saveItem() async {
    if (_addingForm.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false, // Kullanıcının dialog dışında bir yere tıklayarak kapatmasını engeller
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(), // İşlem sırasında dönen progress bar
          );
        },
      );
      try {
        // in web browser
        if (kIsWeb) {
          // image uploaded in correct format
          if (webImage != null) {
            _addingForm.currentState!.save();
            // yeni eklenen resmi gönder
            FirebaseStorage customStorage = FirebaseStorage.instanceFor(
              bucket: 'gs://qr-project-7f885.firebasestorage.app',
            );

            String imageType = detectImageType(webImage!)!;

            final storageRef = customStorage.ref();
            final imageRef = storageRef.child(widget.userId).child('mainHeaders').child('$_newlyAddedmainHeaderName.$imageType');

            final metadata = SettableMetadata(
              contentType: "image/$imageType", // İçerik türünü belirtin
            );

            await imageRef.putData(webImage!, metadata).whenComplete(() {
              debugPrint("File Uploaded...");
            });

            String downloadUrl = await imageRef.getDownloadURL();
            // image is sent at this point

            _addingForm.currentState!.save();
            final querySnapshot = await FirebaseFirestore.instance.collection('Users').doc(widget.userId).collection("MainHeaders").get();

            int maxOrder = widget.mainHeaders.length;

            Map<String, dynamic> newMainHeader = {
              'disable': iconButtonKey.currentState?.disableStatus ?? true,
              'order': maxOrder + 1,
              'imageUrl': downloadUrl,
            };

            // yeni eklenen main header'ı firestore database'e gönderiyor
            var sendingAddress = FirebaseFirestore.instance.collection('Users').doc(widget.userId).collection("MainHeaders").doc(_newlyAddedmainHeaderName);

            await sendingAddress.set(newMainHeader);

            Navigator.of(context, rootNavigator: true).pop();
            setState(() {});
            Navigator.of(context).pop({
              'disableStatus': iconButtonKey.currentState?.disableStatus,
              'maxOrder': maxOrder + 1,
              'newMainHeaderName': _newlyAddedmainHeaderName,
              'imageUrl': downloadUrl,
              'newlyAddedImageWeb': webImage,
            });
          }
          // web image is null (no image selected in web)
          else {
            _addingForm.currentState!.save();
            final querySnapshot = await FirebaseFirestore.instance.collection('Users').doc(widget.userId).collection("MainHeaders").get();

            int maxOrder = widget.mainHeaders.length;

            Map<String, dynamic> newMainHeader = {
              'disable': iconButtonKey.currentState?.disableStatus ?? true,
              'order': maxOrder + 1,
              'imageUrl': " ",
            };

            // yeni eklenen main header'ı firestore database'e gönderiyor
            var sendingAddress = FirebaseFirestore.instance.collection('Users').doc(widget.userId).collection("MainHeaders").doc(_newlyAddedmainHeaderName);

            await sendingAddress.set(newMainHeader);

            Navigator.of(context, rootNavigator: true).pop();
            setState(() {});
            Navigator.of(context).pop({
              'disableStatus': iconButtonKey.currentState?.disableStatus,
              'maxOrder': maxOrder + 1,
              'newMainHeaderName': _newlyAddedmainHeaderName,
              'imageUrl': " ",
            });
          }
        }
      } catch (e) {
        debugPrint("Error: $e");
      }
    }
  }

  /* SONRADAN EKLENEN */
  Future<void> _pickImage() async {
    // in mobile
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      // eğer bir resim seçildiyse
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
        // eğer bir resim seçilmediyse
      } else {
        print("No images has been picked");
      }
    }
    // in web browser
    else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      // eğer bir resim seçildiyse
      if (image != null) {
        var imageInBytes = await image.readAsBytes();
        controlWebImage = imageInBytes;

        // yüklenen resim türü istenilen formatta değilse (jpeg, jpg, WebP, png)
        if (detectImageType(controlWebImage!) == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Lütfen desteklenen formatta bir resim yükleyin (jpg, jpeg, png, webp)"),
            ),
          );
          setState(() {
            webImage = null;
          });
        }

        // aşağı yukarı 15 mb'den büyük bir resim yüklendiyse
        else if (getFileSize(controlWebImage!) > 15000000) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Lütfen 15 MB'den küçük bir resim yükleyin"),
            ),
          );
          setState(() {
            webImage = null;
          });
        }
        // dosya türü ve boyutu uygunsa
        else {
          setState(() {
            webImage = controlWebImage;
          });
        }
      }
      // eğer herhangi bir resim seçilmemişse
      else {
        print("No image selected in web");
      }
    }
    // print("webImage: $webImage");
  }
  /* SONRADAN EKLENEN */

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
              // Modern giriş alanı
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Ana Başlık İsmi",
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
              // Modern ikon butonu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Görünürlük Ayarı",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  IconButtonWidget(key: iconButtonKey), // Sağda ikon
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  /* SONRADAN EKLENEN */
                  Container(
                    width: 250,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Arka plan rengi (isteğe bağlı)
                      border: Border.all(
                        color: Colors.grey, // Kenarlık rengi
                        width: 2.0, // Kenarlık kalınlığı
                      ),
                      borderRadius: BorderRadius.circular(8), // Kenarlığın köşe yuvarlaklığı
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Köşe yuvarlaklığı
                      child: Builder(
                        builder: (context) {
                          // in web browser
                          if (kIsWeb) {
                            // image in a correct way is selected
                            if (webImage != null) {
                              return Image.memory(
                                webImage!,
                                width: 250,
                                height: 150,
                                fit: BoxFit.contain, // Resmi kutuya sığdır
                              );
                            }
                            // image not selected
                            else {
                              return Container(
                                width: 250,
                                height: 150,
                                color: Colors.grey,
                                child: const Icon(Icons.image, color: Colors.white),
                              );
                            }
                          }
                          // in mobile
                          else {
                            // image selected
                            if (_pickedImage != null) {
                              return Image.file(
                                _pickedImage!,
                                width: 250,
                                height: 150,
                                fit: BoxFit.contain, // Resmi kutuya sığdır
                              );
                            }
                            // image not selected
                            else {
                              return Container(
                                width: 250,
                                height: 150,
                                color: Colors.grey,
                                child: const Icon(Icons.image, color: Colors.white),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  /* SONRADAN EKLENEN */
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      _pickImage();
                    },
                    label: const Text(
                      "Resim Ekle",
                      style: TextStyle(color: Colors.black),
                    ),
                    icon: const Icon(Icons.image),
                  ),
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
