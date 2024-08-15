import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/constants/CustomLoadingIndicator.dart';
import 'package:flutter_web_dashboard/constants/SnackbarUtils.dart';
import 'package:flutter_web_dashboard/constants/style.dart';
import 'package:flutter_web_dashboard/pages/customer/widgets/delet_dialog.dart';
import 'package:flutter_web_dashboard/pages/customer/widgets/edit_dialog.dart';
import 'package:flutter_web_dashboard/widgets/custom_text.dart';
import 'package:flutter_web_dashboard/helpers/api.dart'; // Ensure correct path
import 'package:flutter_web_dashboard/Model/customer_model.dart'; // Ensure correct path

class CustomerTable extends StatefulWidget {
  const CustomerTable({super.key});

  @override
  _CustomerTableState createState() => _CustomerTableState();
}

class _CustomerTableState extends State<CustomerTable> {
  late Future<List<Customer>> futureCustomers;

  @override
  void initState() {
    super.initState();
    futureCustomers = API().getCustomer('https://localhost:7086/api/Customer');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Customer>>(
      future: futureCustomers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CustomLoadingIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No customers found'));
        } else {
          List<Customer> customers = snapshot.data!;
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
              height: (60 * customers.length) + 40,
              child: DataTable2(
                columnSpacing: 12,
                dataRowHeight: 60,
                headingRowHeight: 40,
                horizontalMargin: 12,
                minWidth: 600,
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Phone Number')),
                  DataColumn(label: Text('Action 1')),
                  DataColumn(label: Text('Action 2')),
                ],
                rows: customers.map((customer) {
                  return DataRow(
                    cells: [
                      DataCell(Text(customer.name)),
                      DataCell(Text(customer.contact.phoneNumber)),
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
                            onTap: () => showEditDialogCustomer(
                              context,
                              customer,
                              _editCustomer,
                            ),
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
                            onTap: () => showDeleteDialogCustomer(
                              context,
                              customer.id,
                              _deleteCustomer,
                            ),
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

  Future<bool> _editCustomer(Customer customer) async {
    try {
      bool success = await API()
          .updateCustomer('https://localhost:7086/api/Customer', customer);
      if (success) {
        setState(() {
          futureCustomers =
              API().getCustomer('https://localhost:7086/api/Customer');
        });
        SnackbarUtils.showCustomSnackbar(
          title: 'Success',
          message: 'The Edit done successfully',
          backgroundColor: const Color.fromARGB(255, 54, 162, 244),
        );
      } else {
        SnackbarUtils.showCustomSnackbar(
          title: 'Failed',
          message: 'The Edit Failed',
          backgroundColor: const Color.fromARGB(255, 54, 162, 244),
        );
      }
      return success;
    } catch (e) {
      print('Edit customer error: $e');
      SnackbarUtils.showCustomSnackbar(
        title: 'Error',
        message: 'An error occurred: $e',
        backgroundColor: Colors.red,
      );
      return false;
    }
  }

  Future<bool> _deleteCustomer(int id) async {
    try {
      bool success =
          await API().deleteCustomer('https://localhost:7086/api/Customer', id);
      if (success) {
        setState(() {
          futureCustomers =
              API().getCustomer('https://localhost:7086/api/Customer');
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Customer deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete customer')),
        );
      }
      return success;
    } catch (e) {
      print('Delete customer error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
      return false;
    }
  }
}
