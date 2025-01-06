import 'package:flutter/material.dart';

class AddGuidePage extends StatefulWidget {
  const AddGuidePage({super.key});

  @override
  _AddGuidePageState createState() => _AddGuidePageState();
}

class _AddGuidePageState extends State<AddGuidePage> {
  final _formKey = GlobalKey<FormState>();

  // Form Fields
  String? _guideType;
  String? _partReplacement;
  String? _deviceBrand;
  String? _deviceModel;
  String? _deviceYear;
  String? _title;
  String? _difficulty;
  String? _prerequisites;
  List<String> tools = [];
  List<Map<String, String>> guideSteps = []; // To store steps with titles and instructions

  // Dropdown list for difficulty levels
  final List<String> _difficultyLevels = [
    'Very Easy', 'Easy', 'Moderate', 'Difficult', 'Very Difficult'
  ];

  final List<String> _guideTypes = ['Replacement', 'Disassembly', 'Teardown', 'Technique'];

  // Function to add tool names dynamically
  void _addTool(String tool) {
    setState(() {
      tools.add(tool);
    });
  }

  // Function to add guide step
  void _addGuideStep(String stepTitle, String instruction) {
    setState(() {
      guideSteps.add({'title': stepTitle, 'instruction': instruction});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Guide'),
        backgroundColor: Colors.deepPurple.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Section 1: Guide Introduction
                const Text('Section 1: Introduction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _guideType,
                  hint: const Text('What type of guide is this?'),
                  onChanged: (value) {
                    setState(() {
                      _guideType = value;
                    });
                  },
                  items: _guideTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'Please select a guide type' : null,
                ),
                const SizedBox(height: 10),
                // Device Details
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Brand Name'),
                  onChanged: (value) {
                    setState(() {
                      _deviceBrand = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Model Name'),
                  onChanged: (value) {
                    setState(() {
                      _deviceModel = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Year of Introduction'),
                  onChanged: (value) {
                    setState(() {
                      _deviceYear = value;
                    });
                  },
                ),
                const SizedBox(height: 10),

                // For Replacement and Disassembly, ask for the part to replace/disassemble
                if (_guideType == 'Replacement' || _guideType == 'Disassembly')
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'What part are you replacing or disassembling?',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _partReplacement = value;
                      });
                    },
                  ),
                const SizedBox(height: 10),

                // Title - Autofilled based on selections
                TextFormField(
                  initialValue: _title ?? '${_deviceBrand ?? ""} ${_deviceModel ?? ""} ${_partReplacement ?? ""} ${_guideType ?? ""}',
                  decoration: const InputDecoration(labelText: 'Guide Title'),
                  onChanged: (value) {
                    setState(() {
                      _title = value;
                    });
                  },
                  readOnly: true, // Title will autofill based on other fields
                ),

                const SizedBox(height: 20),

                // Section 2: Time Estimation & Difficulty Estimation
                const Text('Section 2: Time & Difficulty Estimation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Time Estimation (in hours)'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _difficulty,
                  hint: const Text('Difficulty Estimation'),
                  onChanged: (value) {
                    setState(() {
                      _difficulty = value;
                    });
                  },
                  items: _difficultyLevels.map((level) {
                    return DropdownMenuItem<String>(
                      value: level,
                      child: Text(level),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'Please select a difficulty level' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Prerequisite Guides (if any)'),
                  onChanged: (value) {
                    setState(() {
                      _prerequisites = value;
                    });
                  },
                ),
                const SizedBox(height: 10),

                // Tools Section
                const Text('Tools:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Tool Name'),
                  onChanged: (tool) {
                    // Add tool to list
                    _addTool(tool);
                  },
                ),
                const SizedBox(height: 10),

                // Display added tools
                if (tools.isNotEmpty)
                  Column(
                    children: tools.map((tool) {
                      return ListTile(
                        title: Text(tool),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              tools.remove(tool);
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 20),

                // Section 3: Guide Steps
                const Text('Section 3: Guide Steps', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Step Title for Step 1'),
                  onChanged: (stepTitle) {
                    // Add the first step dynamically
                    _addGuideStep(stepTitle, '');
                  },
                ),
                const SizedBox(height: 10),

                // List the guide steps
                for (var step in guideSteps)
                  Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Instruction for ${step['title']}'),
                        onChanged: (instruction) {
                          setState(() {
                            step['instruction'] = instruction;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle the form submission logic here
                    }
                  },
                  child: const Text('Submit Guide'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
