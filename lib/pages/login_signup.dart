// Import necessary packages and custom components
import 'package:flutter/material.dart'; // Core package for building UIs
import 'package:qrproject/pages/anasayfa/home_page.dart'; // Import for Home Page
import 'package:qrproject/pages/fiyatlandirma/pricing.dart'; // Import for Pricing Page
import 'package:qrproject/pages/giris_sayfasi/login_page.dart'; // Import for Login Page
import 'package:qrproject/pages/kayit_olma_sayfasi/signup_page.dart'; // Import for Signup Page
import 'package:qrproject/pages/ozellikler/features.dart'; // Import for Features Page
import 'package:qrproject/pages/referanslar/references.dart'; // Import for References Page
import '../widgets/footer.dart'; // Import for Footer widget

// Stateful widget that represents the authentication page
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState(); // Returns the associated state
}

// State class for managing the behavior and state of AuthPage
class _AuthPageState extends State<AuthPage> {
  // PageController for handling page transitions in the PageView
  final PageController _pageController = PageController();

  // TextEditingController instances for capturing email and password input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Dispose method to clean up controllers when the widget is removed from the widget tree
  @override
  void dispose() {
    _emailController.dispose(); // Release the email controller's resources
    _passwordController.dispose(); // Release the password controller's resources
    super.dispose(); // Call the superclass dispose method
  }

  @override
  Widget build(BuildContext context) {
    // Build the main UI structure of the page
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight), // Custom app bar height
        child: Container(
          // Gradient decoration for the app bar background
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent], // Gradient colors
              begin: Alignment.topLeft, // Start point of the gradient
              end: Alignment.bottomRight, // End point of the gradient
            ),
          ),
          // App bar with transparent background and no shadow
          child: AppBar(
            backgroundColor: Colors.transparent, // Transparent background
            elevation: 0, // No shadow
            title: const Text(
              "QR Menü", // Title of the app bar
              style: TextStyle(
                fontSize: 24, // Font size of the title
                fontWeight: FontWeight.bold, // Font weight
                color: Colors.white, // Text color
              ),
            ),
            automaticallyImplyLeading: false, // Hide the default back button
            actions: [
              // Button for navigating to the Home Page
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()), // Navigate to HomePage
                  );
                },
                child: const Text(
                  "Ana Sayfa", // "Home" in Turkish
                  style: TextStyle(color: Colors.white, fontSize: 16), // Text style
                ),
              ),
              // Button for navigating to the Features Page
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FeaturesPage()), // Navigate to FeaturesPage
                  );
                },
                child: const Text(
                  "Özellikler", // "Features" in Turkish
                  style: TextStyle(color: Colors.white, fontSize: 16), // Text style
                ),
              ),
              // Button for navigating to the Pricing Page
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PricingPage()), // Navigate to PricingPage
                  );
                },
                child: const Text(
                  "Fiyatlandırma", // "Pricing" in Turkish
                  style: TextStyle(color: Colors.white, fontSize: 16), // Text style
                ),
              ),
              // Button for navigating to the References Page
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReferencesPage()), // Navigate to ReferencesPage
                  );
                },
                child: const Text(
                  "Referanslar", // "References" in Turkish
                  style: TextStyle(color: Colors.white, fontSize: 16), // Text style
                ),
              ),
              const SizedBox(width: 16), // Spacer for layout consistency

              // Elevated button for navigating to the Login Page (via PageController)
              ElevatedButton(
                onPressed: () {
                  _pageController.animateToPage(
                    0, // Page index for Login Page
                    duration: const Duration(milliseconds: 500), // Animation duration
                    curve: Curves.easeInOut, // Animation curve for smooth transition
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Button background color
                  foregroundColor: Colors.blueAccent, // Button text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded button shape
                  ),
                ),
                child: const Text("Giriş Yap"), // "Login" in Turkish
              ),
              const SizedBox(width: 8), // Spacer between buttons

              // Elevated button for navigating to the Signup Page (via PageController)
              ElevatedButton(
                onPressed: () {
                  _pageController.animateToPage(
                    1, // Page index for Signup Page
                    duration: const Duration(milliseconds: 500), // Animation duration
                    curve: Curves.easeInOut, // Animation curve for smooth transition
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Button background color
                  foregroundColor: Colors.blueAccent, // Button text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded button shape
                  ),
                ),
                child: const Text("Kayıt Ol"), // "Sign Up" in Turkish
              ),
              const SizedBox(width: 16), // Spacer for layout consistency
            ],
          ),
        ),
      ),
      // Main body of the page with PageView and Footer
      body: Column(
        children: [
          // Expanded widget to make PageView fill available space
          Expanded(
            child: PageView(
              controller: _pageController, // Controller for managing page navigation
              children: [
                LoginPage(pageController: _pageController), // Login Page
                SignupPage(
                  pageController: _pageController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                ), // Signup Page
              ],
            ),
          ),
          const Footer(), // Add footer at the bottom of the page
        ],
      ),
    );
  }
}