import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/pages/adding_supplier_and_customer.dart/forms.dart';
// Import AddSupplierForm

class AddDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add',
          style: TextStyle(color: Colors.blue)), // Adjust title color
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddCustomerForm(),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blue), // Use blue color
              foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white), // White text color
              minimumSize: MaterialStateProperty.all<Size>(
                  Size(200, 50)), // Set button size
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            child: Text('Add Customer', style: TextStyle(fontSize: 18)),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddSupplierForm(),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blue), // Use blue color
              foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white), // White text color
              minimumSize: MaterialStateProperty.all<Size>(
                  Size(200, 50)), // Set button size
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            child: Text('Add Supplier', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
