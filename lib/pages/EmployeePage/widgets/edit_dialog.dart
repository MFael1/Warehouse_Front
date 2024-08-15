import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_web_dashboard/Model/employee_model.dart'; // Ensure correct path
import 'package:flutter_web_dashboard/constants/local_data.dart'; // Import local data
import 'package:dropdown_search/dropdown_search.dart';

Future<void> showEditEmployeeDialog(
  BuildContext context,
  Employee employee,
  List<Role> availableRoles,
  Future<bool> Function(Employee) onEdit,
) {
  final TextEditingController usernameController =
      TextEditingController(text: employee.username);
  final TextEditingController emailController =
      TextEditingController(text: employee.email);
  final TextEditingController hireDateController =
      TextEditingController(text: employee.hireDate.toIso8601String());
  final TextEditingController hourlyWageController =
      TextEditingController(text: employee.hourlyWage.toString());
  final TextEditingController imageController =
      TextEditingController(text: employee.image);
  final TextEditingController passwordController = TextEditingController();

  Facility? selectedFacility;

  try {
    selectedFacility = LocalData.facilities.firstWhere(
      (facility) => facility.id == employee.facility.id,
    );
  } catch (e) {
    print('Facility not found: $e');
  }

  Equipment? selectedEquipment;
  try {
    selectedEquipment = LocalData.equipmentList.firstWhere(
      (equipment) => equipment.id == employee.equipment.id,
    );
  } catch (e) {
    print('Equipment not found: $e');
  }

  List<Role> selectedRoles = List.from(employee.roles);

  return Get.defaultDialog(
    title: "Edit Employee",
    content: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(labelText: "Username"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    controller: hireDateController,
                    decoration: InputDecoration(labelText: "Hire Date"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    controller: hourlyWageController,
                    decoration: InputDecoration(labelText: "Hourly Wage"),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: DropdownSearch<Facility>(
                    items: LocalData.facilities,
                    selectedItem: selectedFacility,
                    itemAsString: (Facility facility) => facility.facilityCode,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Select Facility',
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      ),
                    ),
                    onChanged: (Facility? newFacility) {
                      setState(() {
                        selectedFacility = newFacility;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a facility' : null,
                    dropdownBuilder: (context, facility) =>
                        Text(facility?.facilityCode ?? ''),
                    // mode: DropdownSearchMode.MENU,
                    // showSearchBox: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: DropdownSearch<Equipment>(
                    items: LocalData.equipmentList,
                    selectedItem: selectedEquipment,
                    itemAsString: (Equipment equipment) => equipment.name,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Select Equipment',
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      ),
                    ),
                    onChanged: (Equipment? newEquipment) {
                      setState(() {
                        selectedEquipment = newEquipment;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select an equipment' : null,
                    dropdownBuilder: (context, equipment) =>
                        Text(equipment?.name ?? ''),
                    // mode: DropdownSearchMode.MENU,
                    // showSearchBox: true,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 4.0),
                //   child: TextFormField(
                //     controller: imageController,
                //     decoration: InputDecoration(labelText: "Image URL"),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 4.0),
                //   child: TextFormField(
                //     controller: passwordController,
                //     decoration: InputDecoration(
                //         labelText: "Password (Leave blank to keep unchanged)"),
                //     obscureText: true,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: DropdownSearch<Role>(
                    items: availableRoles,
                    selectedItem:
                        selectedRoles.isNotEmpty ? selectedRoles.first : null,
                    itemAsString: (Role role) => role.name,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Select Role',
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      ),
                    ),
                    onChanged: (Role? newRole) {
                      setState(() {
                        if (newRole != null) {
                          if (selectedRoles.contains(newRole)) {
                            selectedRoles.remove(newRole);
                          } else {
                            selectedRoles.add(newRole);
                          }
                        }
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a role' : null,
                    dropdownBuilder: (context, role) => Text(role?.name ?? ''),
                    // mode: PopupProps.menu,
                    // showSearchBox: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
    confirm: ElevatedButton(
      onPressed: () async {
        final updatedEmployee = Employee(
            id: employee.id,
            username: usernameController.text,
            firstName: employee.firstName,
            lastName: employee.lastName,
            email: emailController.text,
            image: imageController.text,
            hourlyWage: int.parse(hourlyWageController.text),
            hireDate: DateTime.parse(
                hireDateController.text), // Ensure correct format
            facility: selectedFacility ?? employee.facility,
            equipment: selectedEquipment ?? employee.equipment,
            roles: selectedRoles,
            password: passwordController.text.isNotEmpty
                ? passwordController.text
                : employee.password);

        bool success = await onEdit(updatedEmployee);
        if (success) {
          Get.back();
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      child: const Text(
        'Save',
        style: TextStyle(fontSize: 18),
      ),
    ),
    cancel: ElevatedButton(
      onPressed: () {
        Get.back();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      child: const Text(
        'Cancel',
        style: TextStyle(fontSize: 18),
      ),
    ),
  );
}
