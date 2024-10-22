import 'package:qrproject/models/menu_language.dart';
import 'package:country_flags/country_flags.dart'; // Paketi import et

final List<MenuLanguage> languages = [
  MenuLanguage(
    language: Language.turkish,
    flag: CountryFlag.fromCountryCode(
      'TR',
      shape: const Circle(),
    ),
  ),
  MenuLanguage(
    language: Language.english,
    flag: CountryFlag.fromCountryCode(
      'US',
      shape: const Circle(),
    ),
  ),
  MenuLanguage(
    language: Language.russian,
    flag: CountryFlag.fromCountryCode(
      'RU',
      shape: const Circle(),
    ),
  ),
  MenuLanguage(
    language: Language.arabic,
    flag: CountryFlag.fromCountryCode(
      'SA',
      shape: const Circle(),
    ),
  ),
];
