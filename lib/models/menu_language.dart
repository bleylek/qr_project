import 'package:flutter/material.dart';

enum Language {
  turkish,
  english,
  russian,
  arabic,
}

class MenuLanguage {
  MenuLanguage({required this.language, required this.flag});

  final Language language;
  final Widget flag;
}
