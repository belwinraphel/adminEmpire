import '../../domain/entities/employee.dart';

class EmployeeModel extends Employee {
  const EmployeeModel({
    required super.id,
    required super.name,
    required super.role,
    required super.contractType,
    required super.team,
    required super.workspace,
    required super.status,
    required super.attendanceRate,
    required super.profileImageUrl,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      contractType: json['contractType'],
      team: json['team'],
      workspace: json['workspace'],
      status: json['status'],
      attendanceRate: (json['attendanceRate'] as num).toDouble(),
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'contractType': contractType,
      'team': team,
      'workspace': workspace,
      'status': status,
      'attendanceRate': attendanceRate,
      'profileImageUrl': profileImageUrl,
    };
  }
}
