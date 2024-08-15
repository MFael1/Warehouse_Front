import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showDeleteinOrderDialog(
    BuildContext context, int id, Future<bool> Function(int) onDelete) {
  return Get.defaultDialog(
    title: "Delete This Order",
    content: Text("Are you sure you want to delete this Order?"),
    confirm: ElevatedButton(
      onPressed: () async {
        bool success = await onDelete(id);
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
        'Yes',
        style: TextStyle(fontSize: 18),
      ),
    ),
    cancel: ElevatedButton(
      onPressed: () {
        Get.back();
      },
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(Color.fromARGB(255, 240, 4, 4)),
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
        'No',
        style: TextStyle(fontSize: 18),
      ),
    ),
  );
}
