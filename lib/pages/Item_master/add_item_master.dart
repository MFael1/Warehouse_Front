import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/Model/Item.dart';
import 'package:flutter_web_dashboard/Model/category_model.dart';
import 'package:flutter_web_dashboard/Model/company_model.dart';
import 'package:flutter_web_dashboard/Model/employee_model.dart';
import 'package:flutter_web_dashboard/constants/local_data.dart';
import 'package:flutter_web_dashboard/controllers/item_master_controller.dart';
import 'package:flutter_web_dashboard/pages/Item_master/widgets/DateFormFieldWidget.dart';
import 'package:flutter_web_dashboard/pages/Item_master/widgets/TextFormFieldWidget.dart';
import 'package:flutter_web_dashboard/pages/inboundPurchaseOrder/widgets/ElevatedButtonWidget.dart';
import 'package:get/get.dart';

class ItemMaterFormPage extends StatelessWidget {
  final ItemFormController controller = Get.put(ItemFormController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Form(
            key: controller.itemasterdataFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Dropdown
                DropdownSearch<Item>(
                  items: controller.itemsList,
                  itemAsString: (Item item) => item.name,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: 'Select Item',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: 'Search Item...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    itemBuilder: (context, item, isSelected) {
                      return ListTile(
                        title: Text(item.name),
                        selected: isSelected,
                      );
                    },
                  ),
                  onChanged: (Item? newValue) {
                    if (newValue != null) {
                      controller.selectedItem.value = newValue;
                      controller.selectedItemId.value = newValue.id;
                    }
                  },
                ),

                SizedBox(height: 16),

                // Company Dropdown
                DropdownSearch<Company>(
                  items: LocalData.company,
                  itemAsString: (Company company) => company.companyName,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: 'Select Company',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: 'Search Company...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    itemBuilder: (context, item, isSelected) {
                      return ListTile(
                        title: Text(item.companyName),
                        selected: isSelected,
                      );
                    },
                  ),
                  onChanged: (Company? newValue) {
                    if (newValue != null) {
                      controller.selectedCompany.value = newValue;
                    }
                  },
                ),
                SizedBox(height: 16),

                // Facility Dropdown
                DropdownSearch<Facility>(
                  items: LocalData.facilities,
                  itemAsString: (Facility facility) => facility.facilityCode,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: 'Select Facility',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: 'Search Facility...',
                        border: OutlineInputBorder(),
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
                SizedBox(height: 16),

                // Barcode Text Field
                TextFormFieldWidget(
                  controller: controller.barcodeController,
                  labelText: "Barcode",
                ),
                SizedBox(height: 16),

                // Description Text Field
                TextFormFieldWidget(
                  controller: controller.descriptionController,
                  labelText: "Description",
                ),
                SizedBox(height: 16),

                // Physical Dimension Text Field
                TextFormFieldWidget(
                  controller: controller.physicalDimensionController,
                  labelText: "Physical Dimension",
                ),
                SizedBox(height: 16),

                // Technical Specification Text Field
                TextFormFieldWidget(
                  controller: controller.technicalSpecificationController,
                  labelText: "Technical Specification",
                ),
                SizedBox(height: 16),

                // Minimum Order Size Text Field
                TextFormFieldWidget(
                  controller: controller.minimumOrderSizeController,
                  labelText: "Minimum Order Size",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // Time to Manufacture Date Picker
                DateFormFieldWidget(
                  controller: controller.timeToManufactureController,
                  labelText: 'Order Date',
                  onChanged: (date) {
                    controller.timeToManufactureDate.value = date;
                  },
                ),
                SizedBox(height: 16),

                // Purchase Cost Text Field
                TextFormFieldWidget(
                  controller: controller.purchaseCostController,
                  labelText: "Purchase Cost",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // Item Pricing Text Field
                TextFormFieldWidget(
                  controller: controller.itemPricingController,
                  labelText: "Item Pricing",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // Shipping Cost Text Field
                TextFormFieldWidget(
                  controller: controller.shippingCostController,
                  labelText: "Shipping Cost",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // Putaway Type Dropdown
                DropdownSearch<Category>(
                  items: LocalData.category,
                  itemAsString: (Category category) => category.categoryName,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: 'Select Putaway Type',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: 'Search Putaway Type...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    itemBuilder: (context, item, isSelected) {
                      return ListTile(
                        title: Text(item.categoryName),
                        selected: isSelected,
                      );
                    },
                  ),
                  onChanged: (Category? newValue) {
                    if (newValue != null) {
                      controller.selectedCategory.value = newValue;
                    }
                  },
                ),
                SizedBox(height: 16),

                // Submit Button
                ElevatedButtonWidget(
                  onPressed: controller.submitForm,
                  text: "Submit",
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
