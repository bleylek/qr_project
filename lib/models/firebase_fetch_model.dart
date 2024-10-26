// Kahveler
class MainHeader {
  MainHeader({
    // key == mainHeaderName
    required this.mainHeaderName, // Kahveler
    required this.order, // order no
    // imageUrl: null == ""
    this.imageUrl = "", // image url
    required this.disable, // show or not
  });

  final String mainHeaderName;
  final int order;
  final String imageUrl;
  final bool disable;
}

// Türk Kahvesi
class Item {
  Item({
    // key == itemName
    required this.itemName, // Türk Kahvesi
    required this.order, // order no
    // imageUrl: null == ""
    this.imageUrl = "", // image url
    // price: null == -5
    required this.price, // price
    required this.disable, // show or not
    required this.blur, // blur or not
    required this.explanation, // explanation
  });

  final String itemName;
  final int order;
  final String imageUrl;
  final double price;
  final bool disable;
  final bool blur;
  final String explanation;
}

class SubHeader {
  const SubHeader({
    // key == subHeaderName
    required this.subHeaderName, // Sütlü
    required this.order, // order no
    // girmediği takdirde price -5 olacak
    this.price = -5,
  });

  final String subHeaderName;
  final int order;
  final double price;
}
