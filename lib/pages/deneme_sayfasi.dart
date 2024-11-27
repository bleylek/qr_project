import 'dart:io';
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadPage extends StatefulWidget {
  const ImageUploadPage({Key? key}) : super(key: key);

  @override
  State<ImageUploadPage> createState() => _ImageUploadPage();
}

class _ImageUploadPage extends State<ImageUploadPage> {
  File? _pickedImage;
  Uint8List? webImage;
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

  Future<void> _pickImage() async {
    // eğer web'deysek
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
    // eğer web'de değilsek
    else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      // eğer bir resim seçildiyse
      if (image != null) {
        var imageInBytes = await image.readAsBytes();
        controlWebImage = imageInBytes;

        // yüklenen resim türü istenilen formatta değilse (jpeg, jpg, WebP, png)
        if (detectImageType(controlWebImage!) == null) {
          print("Lütfen doğru resim formatı yükleyin");
        }
        // aşağı yukarı 15 mb'den büyük bir resim yüklendiyse
        else if (getFileSize(controlWebImage!) > 15000000) {
          print("Lütfen 15 MB'dan küçük bir resim yükleyin. (dosya boyutu çok büyük)");
        }
        // dosya türü ve boyutu uygunsa
        else {
          setState(() {
            webImage = controlWebImage;
          });
        }
      } else {
        print("No image selected in web");
      }
    }
    // print("webImage: $webImage");
  }

  Future<void> uploadImageToFirebase(Uint8List image) async {
    if (webImage == null) {
      print("Henüz herhangi bir resim seçilmedi");
    } else {
      try {
        print("try içerisinde_____________");
        // Manuel olarak belirlenmiş bucket
        FirebaseStorage customStorage = FirebaseStorage.instanceFor(
          bucket: 'gs://qr-project-7f885.firebasestorage.app',
        );

        detectImageType(webImage!);

        final storageRef = customStorage.ref();
        final imageRef = storageRef.child("upoaded_image.png");

        final metadata = SettableMetadata(
          contentType: "image/png", // İçerik türünü belirtin
        );

        // Uint8List formatındaki veriyi yüklemek
        await imageRef.putData(image, metadata).whenComplete(() {
          debugPrint("File Uploaded...");
        });

        final downloadUrl = await imageRef.getDownloadURL();

        print("The type of the image: ${detectImageType(webImage!)}");
        print("The size of the image: ${getFileSize(webImage!)}");
        print("download url: $downloadUrl");

        debugPrint("Download URL: $downloadUrl");
      } on FirebaseException catch (e) {
        debugPrint("Error uploading image: ${e.message}");
      }
    }
  }
  /*
  
  detectImageType(webImage!);

  int? imageSize = getFileSize(webImage!);
  
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: kIsWeb
                ? (webImage != null && webImage!.isNotEmpty
                    ? Image.memory(webImage!, fit: BoxFit.fill)
                    : const Center(
                        child: Text("Web image not found"),
                      ))
                : (_pickedImage != null && _pickedImage!.existsSync()
                    ? Image.file(_pickedImage!, fit: BoxFit.fill)
                    : const Center(
                        child: Text("Image file not found"),
                      )),
          ),
          TextButton(
            onPressed: () {
              _pickImage();
            },
            child: const Text("Choose an image"),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () {
              if (webImage == null) {
                print("Henüz herhangi bir resim seçilmedi");
              } else {
                uploadImageToFirebase(webImage!);
              }
            },
            child: const Text("Load image"),
          ),
        ],
      ),
    );
  }
}

/*
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({super.key});

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  File? _selectedImageFile;

  Future<void> _pickImage() async {
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
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      // eğer bir resim seçildiyse
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File("a");
        });
      } else {
        print("No image selected in web");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return;
  }
}

class _pickedImage {}

*/

/*
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/show_msg_snack.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({Key? key}) : super(key: key);

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  String downloadedUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Image"),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _customTextButton(
                title: "Upload",
                onPressed: () async {
                  try {
                    final storageRef = FirebaseStorage.instance.ref();
                    final imageRef = storageRef.child("no_image.jpg");
                    final ImagePicker picker = ImagePicker();
                    // Create file metadata including the content type
                    var metadata = SettableMetadata(
                      contentType: "image/jpeg",
                    );
                    XFile? image = await picker.pickImage(source: ImageSource.gallery);

                    if (image != null) {
                      File selectedImagePath = File(image.path);
                      await imageRef.putFile(selectedImagePath, metadata).whenComplete(() {
                        ShowSnack.showToast("Uploaded...");
                      });
                    } else {
                      ShowSnack.showToast("No file selected");
                    }
                  } on FirebaseException catch (e) {
                    // ...
                  }
                }),
            const SizedBox(height: 15),
            _customTextButton(
                title: "Download",
                onPressed: () async {
                  try {
                    final storageRef = FirebaseStorage.instance.ref();
                    final imageRef = storageRef.child("no_image.jpg");
                    var url = await imageRef.getDownloadURL();
                    setState(() {
                      downloadedUrl = url;
                    });
                    print(url);
                  } on FirebaseException catch (e) {
                    // ...
                  }
                }),
            const Text(
              "Result:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.network(
                downloadedUrl,
                height: 190,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customTextButton({required String title, required VoidCallback? onPressed}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green.shade600),
          ),
          onPressed: onPressed,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}


*/

/*

import 'dart:io';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadFileWidget extends StatefulWidget {
  const UploadFileWidget({Key? key}) : super(key: key);

  @override
  State<UploadFileWidget> createState() => _UploadFileWidgetState();
}

class _UploadFileWidgetState extends State<UploadFileWidget> {
  File? _pickedImage;
  Uint8List? webImage;

  File? _selectedImageFile;

  Future<void> _pickImage() async {
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
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      // eğer bir resim seçildiyse
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File("a");
        });
      } else {
        print("No image selected in web");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("GERİ"),
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: kIsWeb
                ? (webImage != null && webImage!.isNotEmpty
                    ? Image.memory(webImage!, fit: BoxFit.fill)
                    : const Center(
                        child: Text("Web image not found"),
                      ))
                : (_pickedImage != null && _pickedImage!.existsSync()
                    ? Image.file(_pickedImage!, fit: BoxFit.fill)
                    : const Center(
                        child: Text("Image file not found"),
                      )),
          ),
          TextButton(
            onPressed: () {
              _pickImage();
            },
            child: const Text("Choose an image"),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}


*/
