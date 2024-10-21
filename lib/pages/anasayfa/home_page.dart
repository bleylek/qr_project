import 'package:flutter/material.dart';
import 'package:qrproject/pages/anasayfa/anasayfa_containers/benefits_container.dart';
import 'package:qrproject/pages/anasayfa/anasayfa_containers/menu_images_container.dart';
import 'package:qrproject/pages/anasayfa/anasayfa_containers/pricing_container.dart';
import 'package:qrproject/widgets/appBar.dart';
import 'package:qrproject/widgets/footer.dart';

import 'anasayfa_containers/slogan_container.dart';

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
        // Make sure there's no additional padding around the footer
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0), // Adjust this as needed
          child: ListView(
            children: const [
              CompanySloganContainer(),
              SizedBox(
                height: 64,
              ),
              // First container
              BenefitsContainer(),
              SizedBox(
                height: 64,
              ),
              // Second container
              MenuImagesContainer(),
              SizedBox(
                height: 64,
              ),
              PricingContainer(),

              SizedBox(
                height: 64,
              ),
              // Footer widget might have padding/margin that needs to be adjusted
              Footer()
            ],
          ),
        ),
      ),
    );
  }
}
