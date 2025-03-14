import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrproject/pages/edit_main_header_page/edit_main_header.dart';
import 'package:qrproject/services/auth_service.dart';

class InitializationPage extends StatefulWidget {
  InitializationPage({super.key, required this.userKey});

  String userKey;

  @override
  State<InitializationPage> createState() {
    return _InitializationPage();
  }
}

class _InitializationPage extends State<InitializationPage> {
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = _langauges[0];
    _selectedCurrency = _currencies[0];
  }

  Future<int> checkDigitalMenuAddress(String digitalMenuAddress) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('Users').get();

      for (var doc in querySnapshot.docs) {
        final docId = doc.id;
        // İlk "_" karakterinin pozisyonunu buluyoruz
        final underscoreIndex = docId.indexOf('_');

        // Eğer "_" varsa, öncesindeki kısmı alıyoruz
        if (underscoreIndex != -1) {
          final beforeUnderscore = docId.substring(0, underscoreIndex);

          // Eğer "_" öncesindeki kısım digitalMenuAddress ile eşleşiyorsa
          if (beforeUnderscore == digitalMenuAddress) {
            return 1; // Eşleşme bulundu
          }
        }
      }
      return 0; // Hiçbir eşleşme bulunmadı
    } catch (e) {
      // Hata durumunda hata mesajını konsola yazdır
      print("Firebase bağlantı hatası: $e");
      return 2; // Firebase bağlantı hatası
    }
  }

  Future<void> setCompanyInfo() async {
    var collectionRef = FirebaseFirestore.instance.collection('Users').doc("${_digitalMenuAddress}_${widget.userKey}");

    Map<String, dynamic> companyInfo = {
      'CompanyName': _companyName,
      'MailAddress': _mailAddress,
      'PhoneNumber': '$selectedCountryCode$_phoneWithoutCountryCode',
      'MenuLanguage': _selectedLanguage,
      'MenuMoneyCurrency': _selectedCurrency,
    };

    try {
      // Verileri Firebase'e gönderiyoruz
      await collectionRef.set(companyInfo);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditMainHeader(userKey: widget.userKey),
        ),
      );

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

      // 1) adres kimse tarafından kullanılmıyor
      if (addressCheck == 0) {
        print("adres okay");
        await setCompanyInfo();

        // 2) adres başka biri tarafından kullanımda
      } else if (addressCheck == 1) {
        print("adres kullanımda");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Adres başka biri tarafından kullanılıyor. Lütfen yeni bir dijital menü adresi seçin"),
          ),
        );
        // 3) firebase bağlantı hatası
      } else if (addressCheck == 2) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Hata"),
              content: const Text("Firebase bağlantı hatası oluştu. Lütfen tekrar deneyin."),
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
    setState(() {
      isLoading = false; // İşlem bittiğinde loading durumunu kaldır
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Çıkış Yap'),
        automaticallyImplyLeading: false, // Geri butonunu gizle
        actions: [
          ElevatedButton(
            onPressed: () async {
              await AuthService().signout();
              // Çıkış yaptıktan sonra giriş sayfasına yönlendir
              // burayı değiştir --> anasayfaya yönlendir
              // mounted kontrolü
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/auth');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Çıkış Yap', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 8.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16),
                          _buildTextField(
                              label: "Company name",
                              onSaved: (value) => _companyName = value!,
                              maxLength: 100,
                              validator: (value) {
                                if (value == null || value.trim().length <= 3) {
                                  return "Company name must be at least 3 characters";
                                } else if (value.trim().length >= 100) {
                                  return "Company name must be shorter than 100 characters";
                                }
                                return null;
                              }),
                          const SizedBox(height: 16),
                          _buildTextField(
                              label: "Digital Menu Address",
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a digital menu address';
                                } else if (value.trim().length <= 3) {
                                  return 'The address must be longer than 3 characters';
                                } else if (!RegExp(r'^[a-zA-Z0-9-_]+$').hasMatch(value)) {
                                  return 'The address can only contain letters, numbers, "-" and "_"';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _digitalMenuAddress = value!;
                              }),
                          const SizedBox(height: 16),
                          _buildDropdownField(
                              label: "Language",
                              value: _selectedLanguage,
                              items: _langauges,
                              onChanged: (value) {
                                setState(() {
                                  _selectedLanguage = value;
                                });
                              }),
                          const SizedBox(height: 16),
                          _buildDropdownField(
                              label: "Currency",
                              value: _selectedCurrency,
                              items: _currencies,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCurrency = value;
                                });
                              }),
                          const SizedBox(height: 16),
                          _buildTextField(
                              label: "Mail Address",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email address';
                                }
                                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _mailAddress = value!;
                              }),
                          const SizedBox(height: 16),

                          // Country Code ve Phone Number aynı satırda olacak şekilde Row içinde tanımlandı
                          Row(
                            children: [
                              Expanded(
                                flex: 1, // Country Code için alan
                                child: _buildDropdownField(
                                  label: "Country Code",
                                  value: selectedCountryCode,
                                  items: ['+90', '+1', '+44', '+49', '+33'],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCountryCode = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16), // Boşluk ekledim
                              Expanded(
                                flex: 2, // Phone Number için daha fazla alan
                                child: _buildTextField(
                                  label: "Phone Number",
                                  maxLength: 10,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your phone number';
                                    }
                                    final phoneRegex = RegExp(r'^[0-9]{10}$');
                                    if (!phoneRegex.hasMatch(value)) {
                                      return 'Please enter a valid 10-digit phone number';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _phoneWithoutCountryCode = value!;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _saveItem,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(16.0),
                            ),
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      value: value,
      items: items.map<DropdownMenuItem<String>>((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
