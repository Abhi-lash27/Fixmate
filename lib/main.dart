import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fixmate/pages/AnimatedSplashScreen.dart';
import 'package:fixmate/pages/featurestour_page.dart';
import 'package:fixmate/pages/login_page.dart'; // Import SignInPage
import 'package:fixmate/pages/dashboard_page.dart'; // Import DashboardPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fixmate',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: AuthWrapper(), // Wrapper to determine initial screen
      routes: {
        '/features-tour': (context) => const FeatureTourPage(),
        '/sign-in': (context) => const SignInPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}

// A widget that checks the user's authentication state
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the user is logged in, navigate to Dashboard
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return const DashboardPage();
          } else {
            return const AnimatedSplashScreen();
          }
        }

        // Show a loading indicator while checking authentication status
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
