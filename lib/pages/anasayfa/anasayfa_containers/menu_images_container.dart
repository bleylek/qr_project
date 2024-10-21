import 'dart:async';

import 'package:flutter/material.dart';

class MenuImagesContainer extends StatelessWidget {
  const MenuImagesContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 512,
      padding: const EdgeInsets.only(
          top: 32.0, bottom: 32.0, left: 32.0, right: 32.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(44, 0, 0, 0),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: const ImageCarousel(),
    );
  }
}

enum ImageAssets {
  image1("lib/images/phone-image.png"),
  image2("lib/images/phone-image2.png"),
  image3("lib/images/phone-image3.png"),
  image4("lib/images/phone-image4.png"),
  image5("lib/images/phone-image5.png"),
  image6("lib/images/phone-image6.png"),
  image7("lib/images/phone-image7.png"),
  image8("lib/images/phone-image8.png"),
  image9("lib/images/phone-image9.png"),
  image10("lib/images/phone-image10.png"),
  image11("lib/images/phone-image11.png"),
  image12("lib/images/phone-image12.png"),
  image13("lib/images/phone-image13.png"),
  image14("lib/images/phone-image14.png"),
  image15("lib/images/phone-image15.png"),
  image16("lib/images/phone-image16.png");

  final String path;

  const ImageAssets(this.path);
}

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int currentIndex = 0;
  double opacity = 1.0; // Opaklık kontrolü için
  Timer? timer; // Zamanlayıcı
  final Duration autoSlideDuration = const Duration(seconds: 7); //BURASI

  // Toplam 16 resmin listesini oluşturun
  final List<ImageAssets> images = ImageAssets.values;

  @override
  void initState() {
    super.initState();
    startAutoSlide(); // Otomatik kaydırmayı başlat
  }

  void startAutoSlide() {
    timer = Timer.periodic(autoSlideDuration, (timer) {
      nextImages(); // Her 7 saniyede bir resmi değiştir
    });
  }

  void nextImages() {
    setState(() {
      opacity = 0.0; // Opaklığı sıfıra düşür
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        currentIndex = (currentIndex + 1) %
            (images.length ~/ 4); // 4'er gruplar halinde döngü
        opacity = 1.0; // Yeni resmin opaklığını artır
      });
    });

    resetTimer(); // Zamanlayıcıyı sıfırla
  }

  void previousImages() {
    setState(() {
      opacity = 0.0; // Opaklığı sıfıra düşür
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        currentIndex = (currentIndex - 1 + (images.length ~/ 4)) %
            (images.length ~/ 4); // 4'er gruplar halinde döngü
        opacity = 1.0; // Yeni resmin opaklığını artır
      });
    });

    resetTimer(); // Zamanlayıcıyı sıfırla
  }

  void resetTimer() {
    timer?.cancel(); // Eski zamanlayıcıyı iptal et
    startAutoSlide(); // Yeni zamanlayıcıyı başlat
  }

  @override
  void dispose() {
    timer?.cancel(); // Zamanlayıcıyı iptal et
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int startIndex = currentIndex * 4;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselArrow(
          icon: Icons.arrow_back_ios_rounded, // Geri ok simgesi
          onPressed: previousImages,
        ),
        ImageRow(
          images: images.sublist(startIndex, startIndex + 4),
          opacity: opacity,
        ),
        CarouselArrow(
          icon: Icons.arrow_forward_ios_rounded, // İleri ok simgesi
          onPressed: nextImages,
        ),
      ],
    );
  }
}

class ImageRow extends StatelessWidget {
  final List<ImageAssets> images;
  final double opacity;

  const ImageRow({
    super.key,
    required this.images,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (ImageAssets image in images)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: AnimatedOpacity(
              opacity: opacity, // Opaklık durumu
              duration: const Duration(milliseconds: 500), // Animasyon süresi
              child: ImageItem(
                imagePath: image.path,
              ),
            ),
          ),
      ],
    );
  }
}

class ImageItem extends StatefulWidget {
  const ImageItem({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<ImageItem> createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  double _scale = 1.0;

  void _onEnter(PointerEvent details) {
    setState(() {
      _scale = 1.1; // Resmi büyüt
    });
  }

  void _onExit(PointerEvent details) {
    setState(() {
      _scale = 1.0; // Resmi normale döndür
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0), // Köşe yuvarlama
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.0,
                offset: Offset(0, 4), // Gölge ofseti
              ),
            ],
          ),
          child: Transform.scale(
            scale: _scale, // Resmin büyüklüğü
            child: Image.asset(
              widget.imagePath,
              fit: BoxFit.cover, // Resmin orantılı şekilde sığdırılması
            ),
          ),
        ),
      ),
    );
  }
}

class CarouselArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CarouselArrow({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12.0), // Dışarıda boşluk
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(70, 68, 137, 255),
              Color.fromARGB(70, 223, 64, 251)
            ], // Gradient rengi
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 36.0, // İkon boyutunu artır
          color: Colors.black, // Ok rengi siyah
        ),
      ),
    );
  }
}
