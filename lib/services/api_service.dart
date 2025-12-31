import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  // Local emulator URL (for testing)
  static const String emulatorUrl = "http://127.0.0.1:5001/safeguardai-95296/us-central1/api";
  
  // Production URL (after deployment)
  static const String productionUrl = "https://us-central1-safeguardai-95296.cloudfunctions.net/api";
  
  // Toggle this for production vs development
  static const bool useEmulator = true;
  
  static String get baseUrl => useEmulator ? emulatorUrl : productionUrl;

  /// Analyze content and get decision
  static Future<Map<String, dynamic>> analyzeContent({
    required String childId,
    required String content,
    String? url,
  }) async {
    try {
      // Get Firebase Auth token
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not authenticated");
      }

      final token = await user.getIdToken();

      // Make API request
      final response = await http.post(
        Uri.parse("$baseUrl/analyze"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "childId": childId,
          "content": content,
          "url": url ?? "unknown",
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized: Invalid token");
      } else {
        throw Exception("API error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to analyze content: $e");
    }
  }

  /// Test connection to backend
  static Future<bool> testConnection() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final token = await user.getIdToken();
      final response = await http.post(
        Uri.parse("$baseUrl/analyze"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "childId": "test",
          "content": "test",
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
