import 'package:flutter/material.dart';
import 'welcome_page.dart'; // Import the WelcomePage here

class FeatureTourPage extends StatefulWidget {
  const FeatureTourPage({super.key});

  @override
  _FeatureTourPageState createState() => _FeatureTourPageState();
}

class _FeatureTourPageState extends State<FeatureTourPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              _buildSlide(
                title: 'Feature 1',
                description: 'Discover how Fixmate helps diagnose mobile issues.',
                icon: Icons.phone_android,
                backgroundColor: Colors.blue.shade400,
              ),
              _buildSlide(
                title: 'Feature 2',
                description: 'Repairability score based on diagnostic results.',
                icon: Icons.build,
                backgroundColor: Colors.green.shade400,
              ),
              _buildSlide(
                title: 'Feature 3',
                description: 'Get step-by-step suggestions for repair.',
                icon: Icons.lightbulb_outline,
                backgroundColor: Colors.orange.shade400,
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _currentPage < 2
                    ? TextButton(
                        onPressed: () {
                          _pageController.jumpToPage(2); // Skip to the last page
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : const SizedBox(), // Empty space for last page
                Row(
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _currentPage == index ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                _currentPage < 2
                    ? TextButton(
                        onPressed: () {
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          // Navigate to the WelcomePage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WelcomePage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Get Started',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide({
    required String title,
    required String description,
    required IconData icon,
    required Color backgroundColor,
  }) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 100,
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
