import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InitializationPage extends StatefulWidget {
  InitializationPage({super.key, required this.userKey});

  String userKey;

  @override
  State<InitializationPage> createState() {
    return _InitializationPage();
  }
}

class _InitializationPage extends State<InitializationPage> {
  // Formu kontrol etmek için _formKey tanımladık
  final _formKey = GlobalKey<FormState>();
  final List<String> _langauges = ["Turkish", "English", "Russian", "Arabic"];
  final List<String> _currencies = ["Turkish Lira", "Dollar", "Euro", "Pound"];
  String _companyName = "";
  String? _selectedLanguage;
  String? _selectedCurrency;
  String? selectedCountryCode = '+90';
  String? _mailAddress;
  String? _phoneWithoutCountryCode;
  String _digitalMenuAddress = "";
  bool isLoading = false; // Durum değişkeni
  @override
  void initState() {
    super.initState();
    _selectedLanguage = _langauges[0];
    _selectedCurrency = _currencies[0];
  }

  /*
  Fonksiyon 0 döndürüyorsa: Koleksiyon boş veya adres yok
  Fonksiyon 1 döndürüyorsa: DigitalMenuAddress başka biri tarafından kullanılıyor
  Fonksiyon 2 döndürüyorsa: Firebase bağlantısı kurulamıyor
   */

  Future<int> checkDigitalMenuAddress(String address) async {
    print("Fonksiyon içerisinde____________________");
    try {
      // Firestore referansını al
      final firestore = FirebaseFirestore.instance;

      // DigitalAddresses koleksiyonunu sorgula
      final querySnapshot =
          await firestore.collection('DigitalAddresses').get();

      // Koleksiyon boşsa
      if (querySnapshot.docs.isEmpty) {
        return 0; // Koleksiyon boş
      }

      // Belirtilen adresin belgeler içinde olup olmadığını kontrol et
      final addressSnapshot =
          await firestore.collection('DigitalAddresses').doc(address).get();

      // Eğer belge bulunursa adres kullanımda demektir
      if (addressSnapshot.exists) {
        return 1; // Adres kullanımda
      }

      // Adres koleksiyonda yoksa
      return 0; // Adres kullanımda değil
    } catch (e) {
      // Hata durumunda hata mesajını konsola yazdır
      print("Firebase bağlantı hatası: $e");
      return 2; // Firebase bağlantı hatası
    }
  }

  Future<void> setCompanyInfo() async {
    var collectionRef =
        FirebaseFirestore.instance.collection('Users').doc(widget.userKey);

    Map<String, dynamic> companyInfo = {
      'CompanyName': _companyName,
      'DigitalMenuAddress': _digitalMenuAddress,
      'MailAddress': _mailAddress,
      'PhoneNumber': '$selectedCountryCode$_phoneWithoutCountryCode',
    };

    var digitalMenuAddressRef = FirebaseFirestore.instance
        .collection('DigitalAddresses')
        .doc(_digitalMenuAddress);

    Map<String, dynamic> digitalAddressInfo = {
      'MenuLanguage': _selectedLanguage,
      'MenuMoneyCurrency': _selectedCurrency,
    };

    try {
      // Transaction kullanarak her iki işlemi atomik hale getir
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Digital address bilgilerini Firebase'e gönder
        transaction.set(
            digitalMenuAddressRef, digitalAddressInfo, SetOptions(merge: true));

        // Verileri Firebase'e gönder
        transaction.set(collectionRef, companyInfo, SetOptions(merge: true));
      });

      print("Veriler başarıyla Firebase'e gönderildi.");
    } catch (e) {
      print("Firebase'e veri gönderilirken hata oluştu: $e");
    }
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true; // İşlem başlarken loading durumunu ayarla
      });

      // Adres kontrolü için asenkron fonksiyonu çağır
      int addressCheck = await checkDigitalMenuAddress(_digitalMenuAddress);

      // Hala mounted ise setState ve context işlemlerini kullan
      if (!mounted) return;

      setState(() {
        isLoading = false; // İşlem bittiğinde loading durumunu kaldır
      });

      // 1) adres kimse tarafından kullanılmıyor
      if (addressCheck == 0) {
        print("adres okay");
        await setCompanyInfo();

        // 2) adres başka biri tarafından kullanımda
      } else if (addressCheck == 1) {
        print("adres kullanımda");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Adres başka biri tarafından kullanılıyor. Lütfen yeni bir sijital menü adresi seçin"),
          ),
        );
        // 3) firebase bağlantı hatası
      } else if (addressCheck == 2) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Hata"),
              content: const Text(
                  "Firebase bağlantı hatası oluştu. Lütfen tekrar deneyin."),
              actions: [
                TextButton(
                  child: const Text("Tamam"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Dialog'u kapat
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.0,
              ),
            ],
          ),
          width: double.infinity,
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator() // İlerleme çubuğunu göster
                : Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          maxLength: 150,
                          decoration: const InputDecoration(
                            label: Text("Company name"),
                          ),
                          validator: (value) {
                            // eğer girilen değer 3'den az karakterli ise
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length <= 3) {
                              return "Company name must be at least 3 characters";
                              // eğer girilen değer trimli halde 100'den fazlaysa
                            } else if (value.trim().length >= 100) {
                              return "Company name must be shorter than 100 characters";
                              // no problem
                            } else {
                              return null;
                            }
                          },
                          // onSaved fonksiyonu .save() çağrıldıktan sonra çağrılır
                          onSaved: (value) {
                            _companyName = value!;
                          },
                        ),
                        TextFormField(
                          maxLength: 150,
                          decoration: const InputDecoration(
                            label: Text("Digital Menu Address"),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(
                                r'[a-zA-Z0-9-_]')), // Sadece harfler, rakamlar, "-" ve "_" izin ver
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a digital menu address';
                            } else if (value.trim().length <= 3) {
                              return 'The address must be longer than 3 characters';
                            } else if (!RegExp(r'^[a-zA-Z0-9-_]+$')
                                .hasMatch(value)) {
                              return 'The address can only contain letters, numbers, "-" and "_"';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _digitalMenuAddress = value!;
                          },
                        ),
                        DropdownButtonFormField(
                          value: _selectedLanguage,
                          onChanged: (value) {
                            setState(() {
                              _selectedLanguage = value!;
                            });
                          },
                          items: _langauges
                              .map<DropdownMenuItem<String>>((String language) {
                            return DropdownMenuItem<String>(
                              value: language,
                              child: Text(language),
                            );
                          }).toList(),
                        ),
                        DropdownButtonFormField(
                          value: _selectedCurrency,
                          onChanged: (value) {
                            setState(() {
                              _selectedCurrency = value!;
                            });
                          },
                          items: _currencies
                              .map<DropdownMenuItem<String>>((String currency) {
                            return DropdownMenuItem<String>(
                              value: currency,
                              child: Text(currency),
                            );
                          }).toList(),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text("Mail Address"),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            }
                            // Email format regex
                            final emailRegex =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null; // If email is valid
                          },
                          onSaved: (value) {
                            _mailAddress = value!;
                          },
                        ),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            label: Text("Country Code"),
                          ),
                          value: selectedCountryCode,
                          items:
                              ['+90', '+1', '+44', '+49', '+33'] // Ülke kodları
                                  .map((code) => DropdownMenuItem(
                                        value: code,
                                        child: Text(code),
                                      ))
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCountryCode = value;
                            });
                          },
                        ),
                        TextFormField(
                          maxLength: 10,
                          decoration: const InputDecoration(
                            label: Text("Phone Number"),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            // Simple phone number validation (you can enhance it as needed)
                            final phoneRegex = RegExp(r'^[0-9]{10}$');
                            if (!phoneRegex.hasMatch(value)) {
                              return 'Please enter a valid 10-digit phone number';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]')), // Sadece sayılara izin ver
                          ],
                          onSaved: (value) {
                            _phoneWithoutCountryCode = value!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: _saveItem,
                          child: const Text("Kaydet"),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
