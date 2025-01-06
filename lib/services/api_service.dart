import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'http://192.168.67.208:5000/api/search'; // Replace with actual API URL

  static Future<Map<String, dynamic>?> searchDeviceRepairSolutions(
      String brand, String model, int age, String problem) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "brand": brand,
          "model": model,
          "age": age,
          "problem": problem,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      throw Exception('Error occurred: ${e.toString()}');
    }
  }
}
