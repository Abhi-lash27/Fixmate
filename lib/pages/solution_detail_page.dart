import 'package:flutter/material.dart';

class SolutionDetailPage extends StatelessWidget {
  final Map<String, dynamic> solution;

  const SolutionDetailPage({Key? key, required this.solution}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String problem = solution['problem'] ?? 'Unknown Problem';
    final String repairabilityScore = solution['repairability_score']?.toString() ?? 'N/A';

    // Extract solutions
    final List<Map<String, dynamic>> solutions =
        List<Map<String, dynamic>>.from(solution['solutions'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solution Details' ,style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Problem Description
              Text(
                'Problem:',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(problem, style: const TextStyle(fontSize: 16)),

              const SizedBox(height: 20),

              // 🔹 Repairability Score
              Text(
                'Repairability Score:',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(repairabilityScore, style: const TextStyle(fontSize: 16)),

              const SizedBox(height: 20),

              // 🔹 Solutions Section
              Text(
                'Solutions:',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              solutions.isNotEmpty
                  ? Column(
                      children: solutions.map((solution) {
                        return _buildSolutionCard(context, solution);
                      }).toList(),
                    )
                  : const Text(
                      'No solutions available.',
                      style: TextStyle(fontSize: 16),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Widget to Display Each Solution
  Widget _buildSolutionCard(BuildContext context, Map<String, dynamic> solution) {
    final String solutionDescription = solution['description'] ?? 'No solution available';
    final List<Map<String, dynamic>> steps = List<Map<String, dynamic>>.from(solution['steps'] ?? []);
    final List<Map<String, dynamic>> tools = List<Map<String, dynamic>>.from(solution['tools'] ?? []);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Solution Description
            Text(
              'Solution: $solutionDescription',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // 🔹 Steps Section
            Text(
              'Step-by-Step Instructions:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            steps.isNotEmpty
                ? Column(
                    children: steps.map((step) => _buildStepCard(step)).toList(),
                  )
                : const Text('No steps available.', style: TextStyle(fontSize: 14)),

            const SizedBox(height: 10),

            // 🔹 Tools Section
            if (tools.isNotEmpty) ...[
              Text(
                'Required Tools:',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: tools.map((tool) => _buildToolCard(tool)).toList(),
              ),
            ],
          ],
        ),
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
