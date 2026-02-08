import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/employee_model.dart';
import '../models/kpi_model.dart';

abstract class DashboardRemoteDataSource {
  Future<List<KPIModel>> getDashboardStats();
  Future<List<EmployeeModel>> getEmployees();
}

// --- Implementations ---

/// Simulates a Firebase Data Source (or uses real Firestore if configured)
class DashboardFirebaseDataSource implements DashboardRemoteDataSource {
  @override
  Future<List<KPIModel>> getDashboardStats() async {
    // Simulate network delay for Firebase
    await Future.delayed(const Duration(milliseconds: 800));
    final String jsonString = '''
      [
        {
          "label": "Total Revenue",
          "value": "\$128,450",
          "percentageChange": 15.2,
          "isPositiveTrend": true
        },
        {
          "label": "Total Orders",
          "value": "24,500",
          "percentageChange": 8.5,
          "isPositiveTrend": true
        },
        {
          "label": "Avg. Order Value",
          "value": "\$85.20",
          "percentageChange": 2.1,
          "isPositiveTrend": false
        },
        {
          "label": "Conversion Rate",
          "value": "3.15%",
          "percentageChange": 12.5,
          "isPositiveTrend": true
        }
      ]
    ''';
    return compute(_parseKPIs, jsonString);
  }

  @override
  Future<List<EmployeeModel>> getEmployees() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    const jsonString = '''
    [
      {
        "id": "#ORD-7829",
        "name": "Nike Air Jordan High",
        "role": "Alex Morgan",
        "contractType": "12 Oct, 2024",
        "team": "\$245.00",
        "workspace": "Credit Card",
        "status": "Completed",
        "attendanceRate": 100,
        "profileImageUrl": "assets/avatar1.png"
      },
      {
        "id": "#ORD-7830",
        "name": "Adidas Yeezy 350",
        "role": "Sarah Connor",
        "contractType": "12 Oct, 2024",
        "team": "\$350.00",
        "workspace": "Paypal",
        "status": "Pending",
        "attendanceRate": 60,
        "profileImageUrl": "assets/avatar2.png"
      },
      {
        "id": "#ORD-7831",
        "name": "Puma Running Shorts",
        "role": "Michael Bay",
        "contractType": "11 Oct, 2024",
        "team": "\$45.00",
        "workspace": "Debit Card",
        "status": "Processing",
        "attendanceRate": 40,
        "profileImageUrl": "assets/avatar3.png"
      },
       {
        "id": "#ORD-7832",
        "name": "Apple Watch Series 9",
        "role": "Tim Cook",
        "contractType": "10 Oct, 2024",
        "team": "\$399.00",
        "workspace": "Apple Pay",
        "status": "Cancelled",
        "attendanceRate": 0,
        "profileImageUrl": "assets/avatar4.png"
      }
    ]
    ''';
    return compute(_parseEmployees, jsonString);
  }
}

/// Placeholder for REST API Data Source
class DashboardApiDataSource implements DashboardRemoteDataSource {
  // final Dio dio; // In real app, inject Dio
  // DashboardApiDataSource(this.dio);

  @override
  Future<List<KPIModel>> getDashboardStats() async {
    // In future: return await dio.get('/stats')...
    throw UnimplementedError("API Data Source not implemented yet");
  }

  @override
  Future<List<EmployeeModel>> getEmployees() async {
    // In future: return await dio.get('/orders')...
    throw UnimplementedError("API Data Source not implemented yet");
  }
}

// Top-level functions for parsing (must be top-level or static for compute)
List<KPIModel> _parseKPIs(String encodedJson) {
  final List<dynamic> parsed = jsonDecode(encodedJson);
  return parsed
      .map<KPIModel>(
        (json) => KPIModel(
          label: json['label'],
          value: json['value'],
          percentageChange: json['percentageChange'],
          isPositiveTrend: json['isPositiveTrend'],
        ),
      )
      .toList();
}

List<EmployeeModel> _parseEmployees(String encodedJson) {
  final List<dynamic> parsed = jsonDecode(encodedJson);
  return parsed
      .map<EmployeeModel>(
        (json) => EmployeeModel(
          id: json['id'],
          name: json['name'],
          role: json['role'],
          contractType: json['contractType'],
          team: json['team'],
          workspace: json['workspace'],
          status: json['status'],
          attendanceRate: json['attendanceRate'],
          profileImageUrl: json['profileImageUrl'],
        ),
      )
      .toList();
}
