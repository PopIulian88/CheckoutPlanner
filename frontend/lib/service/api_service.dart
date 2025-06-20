import 'dart:convert';
import 'package:frontend/models/schedule.dart';
import 'package:http/http.dart' as http;

import '../models/employee.dart';

class ApiService {
  // Change with local host
  final String baseUrl = 'http://10.0.2.2:8080';

  // Test auth data for employee
  final String username = 'employee';
  final String password = 'password';

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
      throw Exception('Failed to load the schedule');
    }
  }
}
