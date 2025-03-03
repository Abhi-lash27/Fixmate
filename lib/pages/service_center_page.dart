import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'map_page.dart';

class ServiceCenterPage extends StatefulWidget {
  @override
  _ServiceCenterPageState createState() => _ServiceCenterPageState();
}

class _ServiceCenterPageState extends State<ServiceCenterPage> {
  Map<String, List<Map<String, dynamic>>> serviceCenters = {};
  String? selectedBrand;

  @override
  void initState() {
    super.initState();
    _loadServiceCenters();
  }

  // 🔹 Load Service Centers from JSON File
  Future<void> _loadServiceCenters() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/location_data.json');
      List<dynamic> jsonData = json.decode(jsonString);

      Map<String, List<Map<String, dynamic>>> parsedData = {};
      for (var brandData in jsonData) {
        parsedData[brandData['brand']] = List<Map<String, dynamic>>.from(brandData['locations']);
      }

      setState(() {
        serviceCenters = parsedData;
      });
    } catch (error) {
      print("Error loading service center data: $error");
    }
  }

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
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4.0,
        centerTitle: true,
        leading: selectedBrand != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    selectedBrand = null;
                  });
                },
              )
            : null,
      ),
      body: selectedBrand == null ? _buildBrandGrid() : _buildCityList(selectedBrand!),
    );
  }

  // 🔹 GridView for Brands
  Widget _buildBrandGrid() {
    if (serviceCenters.isEmpty) {
      return const Center(child: CircularProgressIndicator()); // Show loader while data loads
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: serviceCenters.keys.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two items per row
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (context, index) {
          final brand = serviceCenters.keys.elementAt(index);
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedBrand = brand;
              });
            },
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              color: Colors.deepPurple.shade100,
              child: Center(
                child: Text(
                  brand,
                  style: TextStyle(
                    color: Colors.deepPurple.shade800,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 🔹 ListView for Cities (Service Centers)
  Widget _buildCityList(String brand) {
    final locations = serviceCenters[brand] ?? [];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final center = locations[index];

          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                center['name'],
                style: TextStyle(
                  color: Colors.deepPurple.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                center['address'] ?? 'Tap to view on Map',
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: Icon(Icons.map, color: Colors.deepPurple.shade800),
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
    );
  }
}
