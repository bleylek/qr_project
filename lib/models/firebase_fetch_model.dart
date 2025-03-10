// Kahveler

import 'dart:io';
import 'dart:typed_data';

class MainHeader {
  MainHeader({
    // key == mainHeaderName
    required this.mainHeaderName, // Kahveler
    required this.order, // order no
    // imageUrl: null == ""
    this.imageUrl = "", // image url
    required this.disable, // show or not
    this.webImage,
    this.mobileImage,
  });

  String mainHeaderName;
  int order;
  String imageUrl;
  bool disable;
  Uint8List? webImage;
  File? mobileImage;
}

// Türk Kahvesi
class Item {
  Item({
    // key == itemName
    required this.docId,
    required this.itemName, // Türk Kahvesi
    required this.order, // order no
    // imageUrl: null == ""
    this.imageUrl = "", // image url
    // price: null == -5
    this.price, // price
    required this.disable, // show or not
    required this.blur, // blur or not
    required this.explanation, // explanation
    this.image,
  });

  String docId;
  String itemName;
  int order;
  String imageUrl;
  double? price;
  bool disable;
  bool blur;
  String explanation;
  Uint8List? image;
}

class SubHeader {
  SubHeader({
    // key == subHeaderName
    required this.subHeaderName, // Sütlü
    required this.order, // order no
    // girmediği takdirde price -5 olacak
    this.price,
  });

  String subHeaderName;
  int order;
  double? price;
}
