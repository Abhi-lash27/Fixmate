import 'package:fixmate/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesome package
import 'login_page.dart'; // Import the LoginPage and SignUpPage

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade800, Colors.deepPurple.shade500], // Gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/samplelogo.png', // Path to your logo image
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 40), // Space

                // Welcome Text
                const Text(
                  'Welcome to Fixmate!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 40), // Space

                // Sign In Button
                _buildElevatedButton(
                  context: context,
                  label: 'Sign In',
                  isPrimary: false,
                  onPressed: () {
                    _navigateToPage(context, const SignInPage());
                  },
                ),
                const SizedBox(height: 20), // Space

                // Sign Up Button
                _buildElevatedButton(
                  context: context,
                  label: 'Sign Up',
                  isPrimary: true,
                  onPressed: () {
                    _navigateToPage(context, const SignUpPage());
                  },
                ),
                const SizedBox(height: 30), // Space

                // Horizontal Line
                const Divider(
                  color: Colors.white,
                  thickness: 1,
                  indent: 50,
                  endIndent: 50,
                ),
                const SizedBox(height: 20), // Space

                // Login with Social Text
                const Text(
                  'Also login with',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20), // Space

                // Social Login Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      icon: FontAwesomeIcons.google,
                      color: Colors.red,
                      onPressed: () {
                        // Handle Google sign-in logic
                      },
                    ),
                    const SizedBox(width: 10), // Space
                    _buildSocialButton(
                      icon: FontAwesomeIcons.facebookF,
                      color: Colors.blue,
                      onPressed: () {
                        // Handle Facebook sign-in logic
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for navigation with slide transition
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  // Helper method for elevated buttons
  Widget _buildElevatedButton({
    required BuildContext context,
    required String label,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.white : Colors.transparent,
        side: isPrimary ? null : const BorderSide(color: Colors.white),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: isPrimary ? 5 : 0,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isPrimary ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  // Helper method for social buttons
  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(10),
        shape: const CircleBorder(),
        elevation: 5,
      ),
      child: FaIcon(
        icon,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
