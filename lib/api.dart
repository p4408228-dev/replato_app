import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Your PC's hotspot IP — phone and PC must be on the same network
  // If the IP changes, update this line
  static const String baseUrl = 'http://10.65.78.129:8080/api';

  static Future<Map<String, dynamic>?> healthCheck() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/test'));
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (_) {}
    return null;
  }

  static Future<List<dynamic>> getDonations() async {
    final res = await http.get(Uri.parse('$baseUrl/donations'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    return [];
  }

  static Future<bool> createDonation(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/donations'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return res.statusCode == 200;
  }
}