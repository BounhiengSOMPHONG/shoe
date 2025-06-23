import 'dart:convert';
import 'package:app_shoe/services/apiconstants.dart';
import 'package:app_shoe/view/Login/login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ApiResponse {
  final bool success;
  final dynamic data;
  final String? message;

  ApiResponse({required this.success, this.data, this.message});
}

class ApiService {
  Future<Map<String, String>> _buildHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // print('Retrieved token: $token'); // Debugging log

    final headers = {'Content-Type': 'application/json'};

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    } else {
      print('Token is null or empty');
    }
    return headers;
  }

  // ตัวอย่าง POST request
  Future<ApiResponse> post(
    String endpoint, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final headers = await _buildHeaders();

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(success: true, data: responseBody);
      }
      if (response.statusCode == 403) {
        Get.dialog(
          AlertDialog(
            title: Text('Unauthorized Access'),
            content: Text('Please log in again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.offAll(Login());
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
        return ApiResponse(
          success: false,
          message: 'Unauthorized access. Please log in again.',
        );
      } else {
        return ApiResponse(
          success: false,
          message: responseBody['message'] ?? 'Request failed',
        );
      }
    } catch (e) {
      return ApiResponse(success: false, message: 'Connection error');
    }
  }

  Future<ApiResponse> get(String endpoint) async {
    try {
      final headers = await _buildHeaders();

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: headers,
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse(success: true, data: responseBody);
      } else {
        return ApiResponse(
          success: false,
          message: responseBody['message'] ?? 'Request failed',
        );
      }
    } catch (e) {
      return ApiResponse(success: false, message: 'Connection error');
    }
  }
}
