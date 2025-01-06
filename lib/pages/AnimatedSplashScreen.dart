import 'package:flutter/material.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  _AnimatedSplashScreenState createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _logoPosition;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textPosition;

  @override
  void initState() {
    super.initState();

    // Animation Controller for managing the timing and duration
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    // Logo fade-in and slide-right animation
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _logoPosition = Tween<Offset>(begin: Offset.zero, end: const Offset(2.0, 0.0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Text fade-in and slide-right animation (for the app name)
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _textPosition = Tween<Offset>(begin: const Offset(0.0, 0.0), end: const Offset(2.0, 0.0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start the animation when the screen is loaded
    _controller.forward();

    // Navigate to Features Tour page after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/features-tour');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade800,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Animation
            SlideTransition(
              position: _logoPosition,
              child: FadeTransition(
                opacity: _logoOpacity,
                child: Image.asset(
                  'assets/images/logo.png',  // Replace with your logo image
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // App Name Animation
            SlideTransition(
              position: _textPosition,
              child: FadeTransition(
                opacity: _textOpacity,
                child: const Text(
                  'Fixmate', // Your application name
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
