import 'package:flutter/material.dart';

class DeviceDetailPage extends StatelessWidget {
  final Map<String, dynamic> deviceData;

  const DeviceDetailPage({Key? key, required this.deviceData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String brand = deviceData['brand'] ?? 'Unknown Brand';
    final String name = deviceData['name'] ?? 'Unknown Name';
    final List<Map<String, dynamic>> problems =
        List<Map<String, dynamic>>.from(deviceData['problems'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text('$brand $name - Problems', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: problems.isNotEmpty
            ? ListView.builder(
                itemCount: problems.length,
                itemBuilder: (context, index) {
                  final problem = problems[index];
                  return _buildProblemCard(context, problem);
                },
              )
            : const Center(
                child: Text(
                  'No problems available for this device.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
      ),
    );
  }

  // 🔹 Widget to Display Each Problem
  Widget _buildProblemCard(BuildContext context, Map<String, dynamic> problem) {
    final String problemDescription = problem['problem_description'] ?? 'No description available';
    final List<Map<String, dynamic>> solutions =
        List<Map<String, dynamic>>.from(problem['solutions'] ?? []);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: Text(
          problemDescription,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        children: solutions.isNotEmpty
            ? solutions.map((solution) => _buildSolutionCard(context, solution)).toList()
            : [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('No solutions available.', style: TextStyle(fontSize: 16)),
                )
              ],
      ),
    );
  }

  // 🔹 Widget to Display Each Solution
  Widget _buildSolutionCard(BuildContext context, Map<String, dynamic> solution) {
    final String solutionDescription = solution['description'] ?? 'No solution available';
    final List<Map<String, dynamic>> steps = List<Map<String, dynamic>>.from(solution['steps'] ?? []);
    final List<Map<String, dynamic>> tools = List<Map<String, dynamic>>.from(solution['tools'] ?? []);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Solution Title
          Text(
            'Solution: $solutionDescription',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // 🔹 Steps Section
          if (steps.isNotEmpty) ...[
            const Text('Step-by-Step Instructions:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Column(children: steps.map((step) => _buildStepCard(step)).toList()),
          ] else
            const Text('No steps available.', style: TextStyle(fontSize: 14)),

          const SizedBox(height: 10),

          // 🔹 Tools Section
          if (tools.isNotEmpty) ...[
            const Text('Required Tools:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Column(children: tools.map((tool) => _buildToolCard(tool)).toList()),
          ],
        ],
      ),
    );
  }

  // 🔹 Widget to Display Each Step
  Widget _buildStepCard(Map<String, dynamic> step) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Description
          Text(
            '- ${step['description'] ?? 'No description available'}',
            style: const TextStyle(fontSize: 14),
          ),

          // Image (if available)
          if (step['photo'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.network(
                step['photo'],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            ),

          // Video Link (if available)
          if (step['video'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Video Available: ${step['video']}',
                style: const TextStyle(color: Colors.blue, fontSize: 14, decoration: TextDecoration.underline),
              ),
            ),
        ],
      ),
    );
  }

  // 🔹 Widget to Display Each Tool
  Widget _buildToolCard(Map<String, dynamic> tool) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          const Icon(Icons.build, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${tool['name']} - ${tool['price']}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
