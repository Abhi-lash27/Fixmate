import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'device_detail_page.dart'; // Ensure correct import

class DeviceListPage extends StatefulWidget {
  final String brandName;

  const DeviceListPage({super.key, required this.brandName});

  @override
  _DeviceListPageState createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  List<Map<String, dynamic>> devices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/train_data.json');
      List<dynamic> jsonData = json.decode(jsonString);

      // Filter devices for the selected brand
      setState(() {
        devices = jsonData
            .where((device) => device['brand'] == widget.brandName)
            .map((device) => {
                  'brand': device['brand'],
                  'name': device['model'],
                  'age': device['age'],
                  'problems': device['problems'] ?? [],
                  'image': device['image'] ?? 'https://example.com/default_device.png',
                })
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading devices: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.brandName, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple.shade800,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : devices.isEmpty
              ? const Center(child: Text('No devices found.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeviceDetailPage(deviceData: devices[index]),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              devices[index]['image'],
                              height: 80,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.devices, size: 80),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              devices[index]['name'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
