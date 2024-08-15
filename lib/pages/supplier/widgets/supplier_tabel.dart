import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/Model/supplier_model.dart';
import 'package:flutter_web_dashboard/constants/CustomLoadingIndicator.dart';
import 'package:flutter_web_dashboard/constants/SnackbarUtils.dart';
import 'package:flutter_web_dashboard/constants/style.dart';
import 'package:flutter_web_dashboard/pages/supplier/widgets/edit_dialog.dart';
import 'package:flutter_web_dashboard/pages/supplier/widgets/delet_dialog.dart';
import 'package:flutter_web_dashboard/widgets/custom_text.dart';
import 'package:flutter_web_dashboard/helpers/api.dart'; // Ensure correct path

class supplierTable extends StatefulWidget {
  const supplierTable({super.key});

  @override
  _supplierTableState createState() => _supplierTableState();
}

class _supplierTableState extends State<supplierTable> {
  late Future<List<Supplier>> futureSupplier;

  @override
  void initState() {
    super.initState();
    futureSupplier = API().getSupplier('https://localhost:7086/api/Supplier');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Supplier>>(
      future: futureSupplier,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CustomLoadingIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No suppliers found'));
        } else {
          List<Supplier> supplies = snapshot.data!;
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
              height: (60 * supplies.length) + 40,
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
                rows: supplies.map((supplier) {
                  return DataRow(
                    cells: [
                      DataCell(Text(supplier.name)),
                      DataCell(Text(supplier.contact.phoneNumber)),
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
                            onTap: () => showEditSupplierDialog(
                              context,
                              supplier,
                              _editSupplier,
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
                            onTap: () => showDeleteSupplierDialog(
                              context,
                              supplier.id,
                              _deleteSupplier,
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

  Future<bool> _editSupplier(Supplier supplier) async {
    try {
      bool success = await API()
          .updateSupplier('https://localhost:7086/api/Supplier', supplier);
      if (success) {
        setState(() {
          futureSupplier =
              API().getSupplier('https://localhost:7086/api/Supplier');
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
      print('Edit supplier error: $e');
      SnackbarUtils.showCustomSnackbar(
        title: 'Error',
        message: 'An error occurred: $e',
        backgroundColor: Colors.red,
      );
      return false;
    }
  }

  Future<bool> _deleteSupplier(int id) async {
    try {
      bool success =
          await API().deleteSupplier('https://localhost:7086/api/Supplier', id);
      if (success) {
        setState(() {
          futureSupplier =
              API().getSupplier('https://localhost:7086/api/Supplier');
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Supplier deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete supplier')),
        );
      }
      return success;
    } catch (e) {
      print('Delete supplier error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
      return false;
    }
  }
}
