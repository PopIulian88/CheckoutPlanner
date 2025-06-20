import 'package:flutter/material.dart';
import 'package:frontend/models/schedule.dart';

import '../service/api_service.dart';
import 'employee.dart';

class MyAppState extends ChangeNotifier {
  final apiService = ApiService();

  List<Schedule> scheduleList = [];
  List<Employee> employeeList = [];

  Future<void> loadSchedule() async {
    scheduleList = await apiService.getSchedule();
    notifyListeners();
  }

  Future<void> loadEmployee() async {
    employeeList = await apiService.getEmployee();
    notifyListeners();
  }
}
