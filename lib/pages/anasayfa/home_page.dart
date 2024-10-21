import 'package:flutter/material.dart';
import 'package:qrproject/pages/anasayfa/anasayfa_containers/benefits_container.dart';
import 'package:qrproject/pages/anasayfa/anasayfa_containers/menu_images_container.dart';
import 'package:qrproject/pages/anasayfa/anasayfa_containers/pricing_container.dart';
import 'package:qrproject/widgets/appBar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Appbar(
            currentPage: "home_page",
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: const [
              // ilk container
              BenefitsContainer(),
              SizedBox(
                height: 64,
              ),
              // ikinci container
              MenuImagesContainer(),
              SizedBox(
                height: 64,
              ),
              PricingContainer(),
            ],
          ),
        ),
      ),
    );
  }
}
