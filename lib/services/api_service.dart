import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.2.208:5000/api';

  /// 🔹 Searches for device repair solutions
  static Future<Map<String, dynamic>?> searchDeviceRepairSolutions(
      String brand, String model, int age, String problem,
      {int page = 1, int perPage = 5}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/search?page=$page&per_page=$perPage'),
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
        return {"error": "Failed to fetch data: ${response.body}"};
      }
    } catch (e) {
      return {"error": "Exception occurred: ${e.toString()}"};
    }
  }

  /// 🔹 Predicts the repairability score using ML model
  static Future<Map<String, dynamic>?> predictRepairabilityScore(
      double complexity, double cost, double time, double availability, double deviceAge) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "complexity": complexity,
          "cost": cost,
          "time": time,
          "availability": availability,
          "device_age": deviceAge,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {"error": "Failed to predict score: ${response.body}"};
      }
    } catch (e) {
      return {"error": "Exception occurred: ${e.toString()}"};
    }
  }
}
