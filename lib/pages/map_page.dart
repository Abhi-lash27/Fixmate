import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapPage extends StatefulWidget {
  final String locationName;
  final double latitude;
  final double longitude;

  const MapPage({
    Key? key,
    required this.locationName,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? currentLocation;
  List<LatLng> routePoints = [];
  double totalDistance = 0.0; // Distance in kilometers
  double estimatedTime = 0.0; // Duration in seconds
  final String apiKey = '5b3ce3597851110001cf6248418358d1a4cd4dc9ac19a687c6707b3b';

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // Function to get the current location
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });

    await fetchRoute();
  }

  // Function to fetch route and distance using OpenRouteService API
  Future<void> fetchRoute() async {
    if (currentLocation == null) return;

    final String url =
        'https://api.openrouteservice.org/v2/directions/driving-car'
        '?api_key=$apiKey'
        '&start=${currentLocation!.longitude},${currentLocation!.latitude}'
        '&end=${widget.longitude},${widget.latitude}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extract route points
        final coordinates = data['features'][0]['geometry']['coordinates'];
        setState(() {
          routePoints = coordinates
              .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
              .toList();
        });

        // Extract total distance in meters and duration in seconds
        final properties = data['features'][0]['properties']['segments'][0];
        setState(() {
          totalDistance = properties['distance'] / 1000; // Convert to kilometers
          estimatedTime = properties['duration']; // Duration in seconds
        });
      } else {
        throw Exception('Failed to fetch route: ${response.body}');
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  // Function to format time (seconds) into hours and minutes
  String formatTime(double seconds) {
    int hours = (seconds ~/ 3600);
    int minutes = ((seconds % 3600) ~/ 60);
    return '${hours > 0 ? '$hours h ' : ''}${minutes} min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.locationName,
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
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (totalDistance > 0)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Total Distance: ${totalDistance.toStringAsFixed(2)} km',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade800, // Primary color
                          ),
                        ),
                        Text(
                          'Estimated Time: ${formatTime(estimatedTime)}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade800, // Primary color
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: FlutterMap(
                    options: MapOptions(
                      center: currentLocation,
                      zoom: 15.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          // Marker for current location
                          Marker(
                            point: currentLocation!,
                            width: 80,
                            height: 80,
                            builder: (context) => Column(
                              children: [
                                Text(
                                  'You are here',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.deepPurple.shade800, // Primary color
                                  ),
                                ),
                                Icon(
                                  Icons.my_location,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                              ],
                            ),
                          ),
                          // Marker for destination
                          Marker(
                            point: LatLng(widget.latitude, widget.longitude),
                            width: 80,
                            height: 80,
                            builder: (context) => Column(
                              children: [
                                Text(
                                  widget.locationName,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.deepPurple.shade800, // Primary color
                                  ),
                                ),
                                Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (routePoints.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: routePoints,
                              color: Colors.blue,
                              strokeWidth: 4.0,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
