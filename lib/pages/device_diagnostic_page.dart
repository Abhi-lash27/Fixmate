import 'package:fixmate/services/api_service.dart';
import 'package:flutter/material.dart';
// Ensure you have a valid `ApiService`
import 'solution_detail_page.dart'; // Page to show detailed solution

class DeviceFormPage extends StatefulWidget {
  const DeviceFormPage({super.key});

  @override
  _DeviceFormPageState createState() => _DeviceFormPageState();
}

class _DeviceFormPageState extends State<DeviceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();

  List<dynamic> _solutions = [];
  String _errorMessage = "";
  bool _isLoading = false;

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = "";
      _solutions = [];
    });

    try {
      final responseData = await ApiService.searchDeviceRepairSolutions(
        _brandController.text.trim(),
        _modelController.text.trim(),
        int.tryParse(_ageController.text.trim()) ?? 0,
        _problemController.text.trim(),
      );

      setState(() {
        if (responseData != null &&
            responseData['results'] != null &&
            responseData['results'].isNotEmpty) {
          _solutions = responseData['results'];
        } else {
          _errorMessage = "No matching solutions found.";
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Diagnostics',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _brandController,
                    decoration: const InputDecoration(
                      labelText: 'Device Brand',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter the device brand'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _modelController,
                    decoration: const InputDecoration(
                      labelText: 'Device Model',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter the device model'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: 'Device Age (in years)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the device age';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Age must be a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _problemController,
                    decoration: const InputDecoration(
                      labelText: 'Problem Description',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please describe the problem'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitData,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 60,
                        ),
                        backgroundColor: Colors.deepPurple.shade800,
                      ),
                      child: Text(
                        _isLoading ? 'Searching...' : 'Submit',
                        style: const TextStyle(fontSize: 18,color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (_isLoading) const CircularProgressIndicator(),
            if (_solutions.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _solutions.length,
                  itemBuilder: (context, index) {
                    final solution = _solutions[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(solution['problem'] ?? 'Unknown Problem'),
                        subtitle: Text(
                          'Repairability Score: ${solution['repairability_score'] ?? 'N/A'}',
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SolutionDetailPage(
                                solution: solution,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
