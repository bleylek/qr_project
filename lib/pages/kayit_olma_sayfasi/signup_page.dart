// Import necessary packages for Flutter UI and custom services
import 'package:flutter/material.dart'; // Core package for building Flutter UIs
import 'package:qrproject/services/auth_service.dart'; // Custom authentication service
import 'package:qrproject/pages/email_verification_page.dart'; // Page for email verification

// Stateful widget that represents the sign-up page
class SignupPage extends StatefulWidget {
  // PageController for handling page navigation and controllers for user input
  final PageController pageController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  // Constructor to initialize the widget's properties
  const SignupPage({
    super.key,
    required this.pageController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<SignupPage> createState() => _SignupPageState(); // Returns the associated state
}

// State class for managing the behavior and state of SignupPage
class _SignupPageState extends State<SignupPage> {
  // Controller for confirming the password input
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Dispose method to release resources when the widget is removed from the widget tree
  @override
  void dispose() {
    _confirmPasswordController.dispose(); // Free the memory for the confirm password controller
    super.dispose(); // Call the superclass dispose method
  }

  @override
  Widget build(BuildContext context) {
    // Main container for the page, including decoration and padding
    return Container(
      // Background gradient decoration for a visually appealing UI
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purpleAccent, Colors.blueAccent], // Gradient colors
          begin: Alignment.topLeft, // Start point of the gradient
          end: Alignment.bottomRight, // End point of the gradient
        ),
      ),
      // Padding to provide consistent spacing around the child widgets
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start horizontally
          children: [
            // Title text for the page
            const Text(
              "Kayıt Ol", // "Sign Up" in Turkish
              style: TextStyle(
                color: Colors.white, // Text color
                fontSize: 32, // Font size
                fontWeight: FontWeight.bold, // Font weight
              ),
            ),
            const SizedBox(height: 32), // Spacer for layout consistency

            // TextField for email input
            TextField(
              controller: widget.emailController, // Controller for capturing email input
              decoration: InputDecoration(
                labelText: "E-posta", // "Email" in Turkish
                labelStyle: const TextStyle(color: Colors.white), // Label text color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16), // Rounded border corners
                ),
                filled: true, // Enables background fill color
                fillColor: Colors.white.withOpacity(0.1), // Semi-transparent background color
              ),
            ),
            const SizedBox(height: 16), // Spacer for layout

            // TextField for password input
            TextField(
              controller: widget.passwordController, // Controller for capturing password input
              obscureText: true, // Hide input for password security
              decoration: InputDecoration(
                labelText: "Şifre", // "Password" in Turkish
                labelStyle: const TextStyle(color: Colors.white), // Label text color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16), // Rounded border corners
                ),
                filled: true, // Enables background fill color
                fillColor: Colors.white.withOpacity(0.1), // Semi-transparent background color
              ),
            ),
            const SizedBox(height: 16), // Spacer for layout

            // TextField for confirming the password input
            TextField(
              controller: _confirmPasswordController, // Controller for capturing confirm password input
              obscureText: true, // Hide input for password security
              decoration: InputDecoration(
                labelText: "Şifreyi Doğrula", // "Confirm Password" in Turkish
                labelStyle: const TextStyle(color: Colors.white), // Label text color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16), // Rounded border corners
                ),
                filled: true, // Enables background fill color
                fillColor: Colors.white.withOpacity(0.1), // Semi-transparent background color
              ),
            ),
            const SizedBox(height: 32), // Spacer for layout

            // ElevatedButton for triggering the sign-up action
            ElevatedButton(
              onPressed: () async {
                // Check if the passwords match
                if (widget.passwordController.text == _confirmPasswordController.text) {
                  // Call the AuthService signup method and await the result
                  bool success = await AuthService().signup(
                    email: widget.emailController.text, // Email input
                    password: widget.passwordController.text, // Password input
                    context: context, // Context for showing SnackBar or navigation
                  );

                  // If the signup fails, show a SnackBar with an error message
                  if (!success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kayıt Başarısız')), // "Sign Up Failed" in Turkish
                    );
                  }
                } else {
                  // If the passwords do not match, show a SnackBar with an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Şifreler uyuşmuyor')), // "Passwords do not match" in Turkish
                  );
                }
              },
              // Button style configurations
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Button background color
                foregroundColor: Colors.blueAccent, // Button text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Rounded button corners
                ),
              ),
              // Button text
              child: const Center(
                child: Text("Kayıt Ol", style: TextStyle(fontSize: 18)), // "Sign Up" in Turkish
              ),
            ),
            const SizedBox(height: 16), // Spacer for layout

            // TextButton for navigating to the login page
            Center(
              child: TextButton(
                onPressed: () {
                  // Use pageController to animate to the login page (page index 0)
                  widget.pageController.animateToPage(
                    0, // Index for the login page
                    duration: const Duration(milliseconds: 500), // Animation duration
                    curve: Curves.easeInOut, // Animation curve
                  );
                },
                child: const Text(
                  "Zaten hesabın var mı? Giriş Yap", // "Already have an account? Login" in Turkish
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