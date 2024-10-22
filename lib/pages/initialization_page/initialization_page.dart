import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  var _isSending = false;
  @override
  void initState() {
    super.initState();
    _selectedLanguage = _langauges[0];
    _selectedCurrency = _currencies[0];
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
          child: Form(
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
                    } else if (!RegExp(r'^[a-zA-Z0-9-_]+$').hasMatch(value)) {
                      return 'The address can only contain letters, numbers, "-" and "_"';
                    }
                    return null;
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
                  items: ['+90', '+1', '+44', '+49', '+33'] // Ülke kodları
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
                /*
                ElevatedButton(
                  onPressed: _isSending ? null : _saveItem,
                  child: _isSending
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(),
                        )
                      : const Text("Add item"),
                ),
                */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
