import 'package:flutter/material.dart';

class SolutionDetailPage extends StatelessWidget {
  final Map<String, dynamic> solution;

  const SolutionDetailPage({Key? key, required this.solution}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String problem = solution['problem'] ?? 'Unknown Problem';
    final String repairabilityScore = solution['repairability_score']?.toString() ?? 'N/A';
    final List<String> steps = List<String>.from(solution['steps'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solution Details'),
        backgroundColor: Colors.deepPurple.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Problem:',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              problem,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Repairability Score:',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              repairabilityScore,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Step-by-Step Instructions:',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            steps.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: steps.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${index + 1}. ',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(
                                  steps[index],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : const Text(
                    'No instructions available.',
                    style: TextStyle(fontSize: 16),
                  ),
          ],
        ),
      ),
    );
  }
}
