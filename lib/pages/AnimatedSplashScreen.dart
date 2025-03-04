import 'package:flutter/material.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  _AnimatedSplashScreenState createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _textSizeAnimation;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();

    // Animation Controller for timing
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Text Zoom-Out Animation
    _textSizeAnimation = Tween<double>(begin: 100, end: 36).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Fade-in Animation
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start animation
    _controller.forward();

    // Navigate to Features Tour page after animation
    Future.delayed(const Duration(seconds: 3), () {
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
        child: FadeTransition(
          opacity: _textOpacity,
          child: AnimatedBuilder(
            animation: _textSizeAnimation,
            builder: (context, child) {
              return Text(
                'Fixmate', // Your app name
                style: TextStyle(
                  fontSize: _textSizeAnimation.value,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
