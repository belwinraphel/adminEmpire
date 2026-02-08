import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String id;
  final String name;
  final String role;
  final String contractType; // e.g., Full Time
  final String team;
  final String workspace; // e.g., Remote, On-site
  final String status; // e.g., Active
  final double attendanceRate;
  final String profileImageUrl;

  const Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.contractType,
    required this.team,
    required this.workspace,
    required this.status,
    required this.attendanceRate,
    required this.profileImageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    role,
    contractType,
    team,
    workspace,
    status,
    attendanceRate,
    profileImageUrl,
  ];
}
