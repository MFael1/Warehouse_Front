import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/Model/employee_model.dart';
import 'package:flutter_web_dashboard/constants/local_data.dart';
import 'package:flutter_web_dashboard/controllers/add_item_controller.dart';
import 'package:flutter_web_dashboard/pages/inboundPurchaseOrder/widgets/DateFormFieldWidget.dart';
import 'package:get/get.dart';

class AddItemPage extends StatelessWidget {
  final AddItemController controller = Get.put(AddItemController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 10,
              ),
            ],
          ),
          child: Form(
            key: controller.additemFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Item',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 24),

                // Name Text Field
                _buildTextField(
                  controller: controller.nameController,
                  labelText: 'Item Name',
                  icon: Icons.label,
                  validator: (value) =>
                      value?.isEmpty == true ? 'Name is required' : null,
                ),
                SizedBox(height: 24),

                // Count Text Field
                _buildTextField(
                  controller: controller.countController,
                  labelText: 'Quantity',
                  icon: Icons.numbers,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty == true ? 'Count is required' : null,
                ),
                SizedBox(height: 24),

                // Manufacturer Date Text Field
                DateFormFieldWidget(
                  controller: controller.manufacturerDateController,
                  labelText: 'Manufacture Date',
                  onChanged: (date) {
                    controller.manufacturerDateController.text = date;
                  },
                ),
                SizedBox(height: 24),

                // Expiring Date Text Field
                DateFormFieldWidget(
                  controller: controller.expiringDateController,
                  labelText: 'Expiry Date',
                  onChanged: (date) {
                    controller.expiringDateController.text = date;
                  },
                ),
                SizedBox(height: 24),

                // Facility Dropdown
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
                SizedBox(height: 24),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: controller.submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 2,
          ),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
