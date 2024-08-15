import 'dart:typed_data';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/Model/employee_model.dart';
import 'package:flutter_web_dashboard/constants/custom_button.dart';
import 'package:flutter_web_dashboard/constants/local_data.dart';
import 'package:flutter_web_dashboard/constants/style.dart';
import 'package:flutter_web_dashboard/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_web_dashboard/controllers/adding_employee_controller.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({Key? key}) : super(key: key);

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final AddingEmployeeController controller =
      Get.put(AddingEmployeeController());
  Uint8List? _imageData;

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: const Color.fromARGB(255, 104, 148, 224), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
      ),
      obscureText: obscureText,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.hireDateController.text =
          picked.toLocal().toString().split(' ')[0];
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _imageData = bytes;
          controller.imageData.value = bytes;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.0,
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Form(
          key: controller.addEmployeeFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: 'Add an Employee',
                size: 24,
                color: dark,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 24.0),
              _buildTextField(
                controller: controller.usernameController,
                labelText: 'Username',
                icon: Icons.person,
                validator: controller.validateUsername,
                onSaved: (value) => controller.username.value = value!,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: controller.passwordController,
                labelText: 'Password',
                icon: Icons.lock,
                obscureText: true,
                validator: controller.validatePassword,
                onSaved: (value) => controller.password.value = value!,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: controller.firstnameController,
                labelText: 'First Name',
                icon: Icons.person,
                validator: controller.validateFirstname,
                onSaved: (value) => controller.firstname.value = value!,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: controller.lastnameController,
                labelText: 'Last Name',
                icon: Icons.person,
                validator: controller.validateLastname,
                onSaved: (value) => controller.lastname.value = value!,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: controller.emailController,
                labelText: 'Email',
                icon: Icons.email,
                validator: controller.validateEmail,
                onSaved: (value) => controller.email.value = value!,
              ),
              const SizedBox(height: 16.0),
              DropdownSearch<Facility>(
                items: LocalData.facilities, // List of Facility objects
                itemAsString: (Facility facility) => facility.facilityCode,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Select Facility',
                    prefixIcon: Icon(Icons.business),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: 'Search Facility...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  itemBuilder: (context, item, isSelected) {
                    return ListTile(
                      title: Text(item.facilityCode),
                      selected: isSelected,
                    );
                  },
                ),
                onChanged: (Facility? newValue) {
                  if (newValue != null) {
                    controller.selectedFacility.value = newValue;
                  }
                },
              ),
              const SizedBox(height: 16.0),
              DropdownSearch<Equipment>(
                items: LocalData.equipmentList, // List of Facility objects
                itemAsString: (Equipment equipment) => equipment.name,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Select Equipment',
                    prefixIcon: Icon(Icons.brightness_high_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: 'Search Equipment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  itemBuilder: (context, item, isSelected) {
                    return ListTile(
                      title: Text(item.name),
                      selected: isSelected,
                    );
                  },
                ),
                onChanged: (Equipment? newValue) {
                  if (newValue != null) {
                    controller.selectedEqupment.value = newValue;
                  }
                },
              ),
              const SizedBox(height: 16.0),
              DropdownSearch<RoleEm>(
                items: LocalData.role, // List of Facility objects
                itemAsString: (RoleEm equipment) => equipment.name,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Select Role',
                    prefixIcon: Icon(Icons.brightness_high_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: 'Search Role...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  itemBuilder: (context, item, isSelected) {
                    return ListTile(
                      title: Text(item.name),
                      selected: isSelected,
                    );
                  },
                ),
                onChanged: (RoleEm? newValue) {
                  if (newValue != null) {
                    controller.selectedRole.value = newValue;
                  }
                },
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: controller.hourlyWageController,
                labelText: 'Hourly Wage',
                icon: Icons.money,
                validator: controller.validateHourlyWage,
                onSaved: (value) => controller.hourlyWage.value = value!,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                readOnly: true,
                controller: controller.hireDateController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  labelText: 'Hire Date',
                  prefixIcon:
                      Icon(Icons.calendar_today, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                ),
                onTap: () => _selectDate(context),
                validator: controller.validateHireDate,
                onSaved: (value) => controller.hireDate.value = value!,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              if (_imageData != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    _imageData!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 24.0),
              Center(
                child: CustomButton(
                  onPressed: () {
                    if (controller.addEmployeeFormKey.currentState
                            ?.validate() ??
                        false) {
                      controller.checkAddEmployee();
                    }
                  },
                  buttonText: 'Add Employee',
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
