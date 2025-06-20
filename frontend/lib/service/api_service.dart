import 'dart:convert';
import 'package:frontend/models/schedule.dart';
import 'package:frontend/models/wishbook.dart';
import 'package:http/http.dart' as http;

import '../models/employee.dart';

class ApiService {
  // Change with local host
  final String baseUrl = 'http://10.0.2.2:8080';

  // Test auth data for employee
  final String username = 'employee';
  final String password = 'password';

  // Test auth data for admin
  final String adminUsername = 'admin';
  final String adminPassword = 'adminpass';

  // SCHEDULE
  Future<List<Schedule>> getSchedule() async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final response = await http.get(Uri.parse('$baseUrl/schedule'),
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Schedule.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load the schedule');
    }
  }

  Future<Schedule> planSchedule(int wishbookId, String date, int employeeId, String shift) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$adminUsername:$adminPassword'))}';

    final response = await http.post(Uri.parse('$baseUrl/schedule/planning'),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': wishbookId,
          'date': date,
          'employeeId': employeeId,
          'shift': shift
        })
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return Schedule.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load the wishbook');
    }
  }

  Future<Schedule> autoPlanSchedule(String date) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$adminUsername:$adminPassword'))}';

    final response = await http.post(Uri.parse('$baseUrl/schedule/planning/auto/$date'),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/json',
        },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return Schedule.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load the wishbook');
    }
  }

  Future<void> deleteSchedule(String date) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$adminUsername:$adminPassword'))}';

    await http.delete(Uri.parse('$baseUrl/schedule/planning/$date'),
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/json',
      },
    );
  }



  // EMPLOYEE
  Future<List<Employee>> getEmployee() async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final response = await http.get(Uri.parse('$baseUrl/employees'),
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load the employee');
    }
  }

  // WISHBOOK
  Future<List<Wishbook>> getWishbook() async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final response = await http.get(Uri.parse('$baseUrl/wishbook'),
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Wishbook.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load the wishbook');
    }
  }

  Future<List<Wishbook>> setWishbook(String date, int employeeId, String shift) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final response = await http.post(Uri.parse('$baseUrl/wishbook'),
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'date': date,
        'employeeId': employeeId,
        'shift': shift
      })
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return [Wishbook.fromJson(jsonMap)];
    } else {
      throw Exception('Failed to load the wishbook');
    }
  }

  Future<void> deleteWishbook(int id) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$adminUsername:$adminPassword'))}';

    await http.delete(Uri.parse('$baseUrl/wishbook/$id'),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/json',
        },
    );
  }
}
