import 'package:flutter/material.dart';

class DeviceDiagnosticsPage extends StatefulWidget {
  const DeviceDiagnosticsPage({super.key});

  @override
  _DeviceDiagnosticsPageState createState() => _DeviceDiagnosticsPageState();
}

class _DeviceDiagnosticsPageState extends State<DeviceDiagnosticsPage> {
  bool _isDiagnosticRunning = false;
  String _diagnosticResult = "";
  String _deviceInfo = "Device: Pixel 6 Pro\nOS: Android 13";

  // Simulate running diagnostics
  Future<void> _runDiagnostics() async {
    setState(() {
      _isDiagnosticRunning = true;
      _diagnosticResult = "";
    });

    // Simulate diagnostic running (e.g., checking battery health, storage, etc.)
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _diagnosticResult = "Battery Health: Good\nStorage: 75% Free\nRAM: Optimal";
        _isDiagnosticRunning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Device Diagnostics',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple.shade800, // App bar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Device Info Section
            const Text(
              'Device Information:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,  // Changed to white
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _deviceInfo,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,  // Changed to a lighter grey
              ),
            ),
            const SizedBox(height: 30),

            // Run Diagnostics Button
            Center(
              child: ElevatedButton(
                onPressed: _isDiagnosticRunning ? null : _runDiagnostics,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 60),
                  backgroundColor: Colors.deepPurple.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  _isDiagnosticRunning ? 'Running Diagnostics...' : 'Run Diagnostics',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Diagnostic Results Section
            if (_isDiagnosticRunning)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_diagnosticResult.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Diagnostic Results:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,  // Changed to white
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _diagnosticResult,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,  // Changed to a lighter grey
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),

            // Suggestions Section
            if (_diagnosticResult.isNotEmpty)
              const Text(
                'Suggestions for Improvement:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,  // Changed to white
                ),
              ),
            if (_diagnosticResult.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    '- Clear unnecessary files to free up storage space.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,  // Changed to a lighter grey
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '- Close background apps to improve RAM usage.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,  // Changed to a lighter grey
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '- Charge your device to maintain battery health.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,  // Changed to a lighter grey
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
