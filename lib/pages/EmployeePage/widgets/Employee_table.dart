import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/constants/CustomLoadingIndicator.dart';
import 'package:flutter_web_dashboard/constants/SnackbarUtils.dart';
import 'package:flutter_web_dashboard/constants/style.dart';
import 'package:flutter_web_dashboard/pages/EmployeePage/widgets/delet_dialog.dart';
import 'package:flutter_web_dashboard/pages/EmployeePage/widgets/edit_dialog.dart'; // Correct the import path
import 'package:flutter_web_dashboard/widgets/custom_text.dart';
import 'package:flutter_web_dashboard/Model/employee_model.dart'; // Ensure correct path
import 'package:flutter_web_dashboard/helpers/api.dart'; // Ensure correct path

class EmployeeTable extends StatefulWidget {
  const EmployeeTable({super.key});

  @override
  _EmployeeTableState createState() => _EmployeeTableState();
}

class _EmployeeTableState extends State<EmployeeTable> {
  late Future<List<Employee>> futureEmployees;
  late Future<List<Role>> futureRoles; // Fetch roles

  @override
  void initState() {
    super.initState();
    futureEmployees = API().getEmployees(); // Fetch employees
    futureRoles = API().getRoles(
        'https://localhost:7086/api/Role'); // Fetch roles (ensure you have this method)
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future:
          Future.wait([futureEmployees, futureRoles]), // Wait for both futures
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CustomLoadingIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No employees found'));
        } else {
          List<Employee> employees = snapshot.data![0] as List<Employee>;
          List<Role> roles =
              snapshot.data![1] as List<Role>; // Correct type casting

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: active.withOpacity(.4), width: .5),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 6),
                    color: lightGrey.withOpacity(.1),
                    blurRadius: 12)
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 30),
            child: SizedBox(
              height: (60 * employees.length) + 40,
              child: DataTable2(
                columnSpacing: 12,
                dataRowHeight: 60,
                headingRowHeight: 40,
                horizontalMargin: 12,
                minWidth: 600,
                border:
                    TableBorder.all(color: active.withOpacity(.4), width: 0.5),
                columns: const [
                  DataColumn(label: Text('Username')),
                  DataColumn(label: Text('First Name')),
                  DataColumn(label: Text('Last Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Hourly Wage')),
                  DataColumn(label: Text('Hire Date')),
                  DataColumn(label: Text('Facility')),
                  DataColumn(label: Text('Equipment')),
                  DataColumn(label: Text('Action 1')),
                  DataColumn(label: Text('Action 2')),
                ],
                rows: employees.map((employee) {
                  return DataRow(
                    cells: [
                      DataCell(Center(child: Text(employee.username))),
                      DataCell(Center(child: Text(employee.firstName))),
                      DataCell(Center(child: Text(employee.lastName))),
                      DataCell(Center(child: Text(employee.email))),
                      DataCell(
                          Center(child: Text(employee.hourlyWage.toString()))),
                      DataCell(Center(
                          child: Text(employee.hireDate.toLocal().toString()))),
                      DataCell(Center(
                          child: Text(employee.facility
                              .facilityCode))), // Ensure correct property
                      DataCell(Center(child: Text(employee.equipment.name))),
                      DataCell(
                        Container(
                          decoration: BoxDecoration(
                            color: light,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: active, width: .5),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: GestureDetector(
                            onTap: () => showEditEmployeeDialog(context,
                                employee, roles, _editEmployee), // Pass roles
                            child: CustomText(
                              text: "Edit",
                              color: active.withOpacity(.7),
                              weight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          decoration: BoxDecoration(
                            color: light,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: active, width: .5),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: GestureDetector(
                            onTap: () => showDeleteEmployeeDialog(
                                context, employee.id, _deleteEmployee),
                            child: CustomText(
                              text: "Delete",
                              color: active.withOpacity(.7),
                              weight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        }
      },
    );
  }

  Future<bool> _deleteEmployee(int id) async {
    try {
      bool success =
          await API().deleteEmployee('https://localhost:7086/api/User', id);
      if (success) {
        setState(() {
          futureEmployees = API().getEmployees();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Employee deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete employee')),
        );
      }
      return success;
    } catch (e) {
      print('Delete employee error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
      return false;
    }
  }

  Future<bool> _editEmployee(Employee employee) async {
    try {
      bool success = await API()
          .updateEmployee('https://localhost:7086/api/User', employee);
      if (success) {
        setState(() {
          futureEmployees = API().getEmployees();
          SnackbarUtils.showCustomSnackbar(
            title: 'Success',
            message: 'The Edit success',
            backgroundColor: const Color.fromARGB(255, 54, 162, 244),
          );
        });
      } else {
        SnackbarUtils.showCustomSnackbar(
          title: 'Failed',
          message: 'The Edit Failed',
          backgroundColor: Color.fromARGB(255, 244, 54, 54),
        );
      }
      return success;
    } catch (e) {
      print('Edit Employee error: $e');
      SnackbarUtils.showCustomSnackbar(
        title: 'Error',
        message: 'An error occurred: $e',
        backgroundColor: Colors.red,
      );
      return false;
    }
  }
}
