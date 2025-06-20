import 'package:flutter/material.dart';
import 'package:frontend/models/schedule.dart';
import 'package:frontend/models/wishbook.dart';

import '../service/api_service.dart';
import 'employee.dart';

class MyAppState extends ChangeNotifier {
  final apiService = ApiService();

  List<Schedule> scheduleList = [];
  List<Employee> employeeList = [];
  List<Wishbook> wishbookList = [];

  Future<void> loadSchedule() async {
    scheduleList = await apiService.getSchedule();
    notifyListeners();
  }

  Future<void> loadEmployee() async {
    employeeList = await apiService.getEmployee();
    notifyListeners();
  }

  Future<void> loadWishbook() async {
    wishbookList = await apiService.getWishbook();
    notifyListeners();
  }

  Future<void> setWishbook(String date, int employeeId, String shift) async {
    await apiService.setWishbook(date, employeeId, shift);

    wishbookList = await apiService.getWishbook();
    notifyListeners();
  }

  Future<void> planSchedule(int wishbookId, String date, int employeeId, String shift) async {
    await apiService.planSchedule(wishbookId, date, employeeId, shift);

    wishbookList = await apiService.getWishbook();
    scheduleList = await apiService.getSchedule();
    notifyListeners();
  }

  Future<void> deleteWishbook(int id) async {
    await apiService.deleteWishbook(id);

    wishbookList = await apiService.getWishbook();
    notifyListeners();
  }

  Future<void> deleteSchedule(String date) async {
    await apiService.deleteSchedule(date);

    scheduleList = await apiService.getSchedule();
    notifyListeners();
  }

  Future<void> autoPlanSchedule(String date) async {
    await apiService.autoPlanSchedule(date);

    wishbookList = await apiService.getWishbook();
    scheduleList = await apiService.getSchedule();
    notifyListeners();
  }
}
