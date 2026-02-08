import 'package:flutter/material.dart';
import '../../domain/entities/employee.dart';

class EmployeeTable extends StatelessWidget {
  final List<Employee> employees;
  final bool isDark;

  const EmployeeTable({
    super.key,
    required this.employees,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark
        ? const Color(0xFF1E1E24)
        : Colors.white; // Assuming white for light mode card
    final textColor = isDark ? Colors.white : const Color(0xFF2C2C2C);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.grey.withOpacity(0.1);
    final subTextColor = isDark ? Colors.grey : Colors.grey;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Orders',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: textColor),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      'All orders',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: textColor),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.keyboard_arrow_down, size: 16, color: textColor),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              horizontalMargin: 0,
              columnSpacing: 40,
              columns: [
                DataColumn(
                  label: Text(
                    'Order ID',
                    style: TextStyle(color: subTextColor),
                  ),
                ),
                DataColumn(
                  label: Text('Product', style: TextStyle(color: subTextColor)),
                ),
                DataColumn(
                  label: Text(
                    'Customer',
                    style: TextStyle(color: subTextColor),
                  ),
                ),
                DataColumn(
                  label: Text('Date', style: TextStyle(color: subTextColor)),
                ),
                DataColumn(
                  label: Text('Amount', style: TextStyle(color: subTextColor)),
                ),
                DataColumn(
                  label: Text('Payment', style: TextStyle(color: subTextColor)),
                ),
                DataColumn(
                  label: Text('Status', style: TextStyle(color: subTextColor)),
                ),
                DataColumn(
                  label: Text('Process', style: TextStyle(color: subTextColor)),
                ),
                DataColumn(
                  label: Text('', style: TextStyle(color: subTextColor)),
                ),
              ],
              rows: employees.map((employee) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(employee.id, style: TextStyle(color: textColor)),
                    ),
                    DataCell(
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.grey,
                            // backgroundImage: AssetImage(employee.profileImageUrl),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            employee.name,
                            style: TextStyle(color: textColor),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Text(employee.role, style: TextStyle(color: textColor)),
                    ),
                    DataCell(
                      Text(
                        employee.contractType,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    DataCell(
                      Text(employee.team, style: TextStyle(color: textColor)),
                    ),
                    DataCell(
                      Text(
                        employee.workspace,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF6C63FF),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            employee.status,
                            style: TextStyle(color: textColor),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: LinearProgressIndicator(
                              value: employee.attendanceRate / 100,
                              backgroundColor: isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.grey.withOpacity(0.2),
                              color: const Color(0xFF6C63FF),
                              minHeight: 4,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${employee.attendanceRate.toInt()}%',
                            style: TextStyle(color: textColor),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Icon(Icons.more_horiz, color: subTextColor)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
