import 'package:flutter/material.dart';
import 'map_page.dart';

class ServiceCenterPage extends StatelessWidget {
  final List<Map<String, dynamic>> serviceCenters = [
    {
      'name': 'Realme Service Center - Bangalore',
      'latitude': 12.9716,
      'longitude': 77.5946,
    },
    {
      'name': 'Realme Service Center - Chennai',
      'latitude': 13.0827,
      'longitude': 80.2707,
    },
    {
      'name': 'Realme Service Center - Hyderabad',
      'latitude': 17.3850,
      'longitude': 78.4867,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Service Centers',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.deepPurple.shade800, // FixMate primary color
        elevation: 4.0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: serviceCenters.length,
          itemBuilder: (context, index) {
            final center = serviceCenters[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(
                  center['name'],
                  style: TextStyle(
                    color: Colors.deepPurple.shade800, // FixMate primary color
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  'Tap to view on Map',
                  style: TextStyle(
                    color: Colors.deepPurple.shade600,
                  ),
                ),
                trailing: Icon(
                  Icons.map,
                  color: Colors.deepPurple.shade800,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapPage(
                        locationName: center['name'],
                        latitude: center['latitude'],
                        longitude: center['longitude'],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
