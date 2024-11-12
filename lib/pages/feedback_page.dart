import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _feedbackController = TextEditingController();
  String? _rating;

  // Method to handle form submission
  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically send the feedback to your backend or Firebase
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your feedback!')),
      );
      _feedbackController.clear();
      setState(() {
        _rating = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: Colors.deepPurple.shade800,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'We value your feedback! Please rate our app and provide any comments.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Rating Section
              const Text(
                'Rate the app:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _rating,
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: '1',
                    child: Text('1 - Poor'),
                  ),
                  DropdownMenuItem(
                    value: '2',
                    child: Text('2 - Fair'),
                  ),
                  DropdownMenuItem(
                    value: '3',
                    child: Text('3 - Good'),
                  ),
                  DropdownMenuItem(
                    value: '4',
                    child: Text('4 - Very Good'),
                  ),
                  DropdownMenuItem(
                    value: '5',
                    child: Text('5 - Excellent'),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Select your rating',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a rating';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Feedback Text Field
              TextFormField(
                controller: _feedbackController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Your Feedback',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide your feedback';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade800,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Submit Feedback',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
