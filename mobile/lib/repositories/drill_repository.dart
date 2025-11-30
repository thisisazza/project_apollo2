import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/drill.dart';

class DrillRepository {
  static const String _baseUrl =
      'http://10.0.2.2:8000'; // Android Emulator localhost

  static Future<List<Drill>> getDrills() async {
    try {
      // Try fetching from backend
      final response = await http
          .get(Uri.parse('$_baseUrl/drills'))
          .timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Drill.fromJson(json)).toList();
      }
    } catch (e) {
      print('Backend unreachable, falling back to assets: $e');
    }

    // Fallback to local assets
    final drillFiles = [
      'assets/drills/drill_001.json',
      'assets/drills/drill_002.json',
      'assets/drills/drill_003.json',
    ];

    List<Drill> drills = [];

    for (final file in drillFiles) {
      try {
        final String jsonString = await rootBundle.loadString(file);
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        drills.add(Drill.fromJson(jsonMap));
      } catch (e) {
        print('Error loading drill $file: $e');
      }
    }
    return drills;
  }
}
