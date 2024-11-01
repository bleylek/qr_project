// Import necessary packages
import 'package:flutter/material.dart'; // Core Flutter package for building UIs
import 'package:shared_preferences/shared_preferences.dart'; // For persistent storage
import 'package:qrproject/pages/forgot_password.dart'; // Page for "Forgot Password"
import 'package:qrproject/pages/login_first_page.dart'; // Page shown after successful login
import 'package:qrproject/services/auth_service.dart'; // Custom authentication service

// LoginPage class extends StatelessWidget and builds a login screen UI
class LoginPage extends StatelessWidget {
  // Controller for the page navigation
  final PageController pageController;
  // Controllers for managing user input in the email and password fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Constructor to initialize the page controller
  LoginPage({Key? key, required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Main container for the login page UI
    return Container(
      // Background gradient decoration for visual appeal
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.purpleAccent], // Gradient colors
          begin: Alignment.topLeft, // Starting point of the gradient
          end: Alignment.bottomRight, // Ending point of the gradient
        ),
      ),
      // Padding around the entire content for layout consistency
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start horizontally
          children: [
            // Title text for the login page
            const Text(
              "Giriş Yap", // "Login" in Turkish
              style: TextStyle(
                color: Colors.white, // Text color
                fontSize: 32, // Font size
                fontWeight: FontWeight.bold, // Font weight
              ),
            ),
            const SizedBox(height: 32), // Spacer for layout

            // TextField for email input
            TextField(
              controller: emailController, // Controller to capture input
              decoration: InputDecoration(
                labelText: "E-posta", // Label text for the input field
                labelStyle: const TextStyle(color: Colors.white), // Label text color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                ),
                filled: true, // Fill color enabled
                fillColor: Colors.white.withOpacity(0.1), // Semi-transparent fill color
              ),
            ),
            const SizedBox(height: 16), // Spacer for layout

            // TextField for password input
            TextField(
              controller: passwordController, // Controller to capture input
              obscureText: true, // Hide the input for security
              decoration: InputDecoration(
                labelText: "Şifre", // "Password" in Turkish
                labelStyle: const TextStyle(color: Colors.white), // Label text color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                ),
                filled: true, // Fill color enabled
                fillColor: Colors.white.withOpacity(0.1), // Semi-transparent fill color
              ),
            ),
            const SizedBox(height: 16), // Spacer for layout

            // "Forgot Password" button
            TextButton(
              onPressed: () {
                // Navigate to the "Forgot Password" page when pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage()),
                );
              },
              child: const Text(
                "Şifreni mi unuttun?", // "Forgot your password?" in Turkish
                style: TextStyle(color: Colors.white), // Text color
              ),
            ),
            const SizedBox(height: 32), // Spacer for layout

            // ElevatedButton for login action
            ElevatedButton(
              onPressed: () async {
                // Call the sign-in method from AuthService with the provided email and password
                bool success = await AuthService().signin(
                  email: emailController.text,
                  password: passwordController.text,
                );

                // If the login is successful, navigate to the LoginFirstPage
                if (success) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginFirstPage()),
                  );
                } else {
                  // If login fails, show a Snackbar with an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Giriş Başarısız'), // "Login Failed" in Turkish
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Button background color
                foregroundColor: Colors.blueAccent, // Button text color
                padding: const EdgeInsets.symmetric(vertical: 16), // Button padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Rounded button shape
                ),
              ),
              // Button text
              child: const Center(
                child: Text("Giriş Yap", style: TextStyle(fontSize: 18)), // "Login" in Turkish
              ),
            ),
            const SizedBox(height: 16), // Spacer for layout

            // TextButton for navigating to the sign-up page
            Center(
              child: TextButton(
                onPressed: () {
                  // Animate to the second page (sign-up) when pressed
                  pageController.animateToPage(
                    1, // Page index
                    duration: const Duration(milliseconds: 500), // Animation duration
                    curve: Curves.easeInOut, // Animation curve
                  );
                },
                child: const Text(
                  "Hesabın yok mu? Kayıt Ol", // "Don't have an account? Sign Up" in Turkish
                  style: TextStyle(color: Colors.white), // Text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
