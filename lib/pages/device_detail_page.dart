import 'package:flutter/material.dart';

class DeviceDetailPage extends StatefulWidget {
  final Map<String, dynamic> device;

  const DeviceDetailPage({super.key, required this.device});

  @override
  _DeviceDetailPageState createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.device['brand']} - ${widget.device['model']}"),
        backgroundColor: Colors.deepPurple.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Model: ${widget.device['model']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Brand: ${widget.device['brand']}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Device Age: ${widget.device['age']} years",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "Common Problems",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.device['problems'].length,
                itemBuilder: (context, index) {
                  var problem = widget.device['problems'][index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(problem['problem_description'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          "Complexity: ${problem['complexity']} | Cost: ${problem['cost']} | Time: ${problem['time']}"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProblemDetailPage(problem: problem),
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

class ProblemDetailPage extends StatelessWidget {
  final Map<String, dynamic> problem;

  const ProblemDetailPage({super.key, required this.problem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(problem['problem_description']),
        backgroundColor: Colors.deepPurple.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Solutions",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...problem['solutions'].map<Widget>((solution) {
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  title: Text(solution['description'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  children: solution['steps'].map<Widget>((step) {
                    return ListTile(
                      leading: step['photo'] != null
                          ? Image.network(step['photo'], width: 50, height: 50, fit: BoxFit.cover)
                          : const Icon(Icons.image_not_supported),
                      title: Text(step['description']),
                      trailing: step['video'] != null
                          ? IconButton(
                              icon: const Icon(Icons.play_circle_fill, color: Colors.red),
                              onPressed: () {
                                // Open video (handle video playback logic here)
                              },
                            )
                          : null,
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
