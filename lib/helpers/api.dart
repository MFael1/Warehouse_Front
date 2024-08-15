import 'dart:convert'; // For jsonDecode
import 'dart:ui';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_dashboard/Model/customer_model.dart';
import 'package:flutter_web_dashboard/Model/employee_model.dart';
import 'package:flutter_web_dashboard/Model/inbound_order.dart';
import 'package:flutter_web_dashboard/Model/out_order_model.dart';
import 'package:flutter_web_dashboard/Model/supplier_model.dart';
import 'package:flutter_web_dashboard/constants/SnackbarUtils.dart';
import 'package:http/http.dart' as http;

class API {
  final storage = const FlutterSecureStorage();
  Future<dynamic> postRequestLogin(
      String url, Map<String, dynamic> data) async {
    try {
      // print('enter to api file');
      // print('Request URL: $url');
      // print('Request Data: ${jsonEncode(data)}');
      // print('api  :: 11');

      var response = await http.post(
        Uri.parse(url),
        headers: {'accept': '*/*', 'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      // print('api :: 22');

      // print('Response Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        String? token = responseBody['token'];
        if (token == null) {
          throw Exception('Token is null');
        }
        await storage.write(key: 'token', value: token);
      }

      return response;
    } catch (e) {
      print('Error Catch from api ($e)');
      return null;
    }
  }

  Future<http.Response?> postAddEmoployee(
      String url, Map<String, dynamic> data) async {
    // print('Sending data: $data');
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found');
      }

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          "Content-type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      print('Error Catch (${e})');
      return null;
    }
  }

  Future<List<Employee>> getEmployees() async {
    const url =
        'https://localhost:7086/api/User'; // Replace with your actual API endpoint

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Log the raw JSON response for debugging
        // print('Raw JSON response: ${response.body}');

        List<dynamic> data = json.decode(response.body);

        // Check for null or incorrect types in the list
        return data
            .where((json) => json != null && json is Map<String, dynamic>)
            .map((json) => Employee.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      print('Error fetching employees: $e');
      throw e;
    }
  }

  Future<bool> deleteEmployee(String url, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$url/$id'),
      );
      if (response.statusCode == 204) {
        return true;
      } else {
        print('Failed to delete customer: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Delete customer API error: $e');
      return false;
    }
  }

  Future<bool> updateEmployee(String url, Employee employee) async {
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('Token is null');
      }
      print('${employee.id}');
      final response = await http.put(
        Uri.parse('$url/${employee.id}'),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user': employee.id,
          'username': employee.username,
          'first_name': employee.firstName,
          'last_name': employee.lastName,
          'email': employee.email,
          'password':
              employee.password ?? '', // Ensure password is included or not
          'image': employee.image,
          'hourly_wage': employee.hourlyWage,
          'hire_date': employee.hireDate
              .toIso8601String()
              .split('T')
              .first, // Format as YYYY-MM-DD
          'facility_id': employee.facility.id,
          'equipment_id': employee.equipment.id,
          'roles': employee.roles.map((role) => role.id).toList(),
        }), // Ensure this matches your API's expectations
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        SnackbarUtils.showCustomSnackbar(
          title: 'Success',
          message: 'The Edit success',
          backgroundColor: const Color.fromARGB(255, 54, 162, 244),
        );
        return true;
      } else {
        print('Failed to update employee: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Update employee API error: $e');
      return false;
    }
  }

// ! Customer Services

  Future<http.Response?> postCustomer(
      String urlApi, Map<String, dynamic> customer) async {
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('Token is null');
      }
      // print('enter to api file');
      // print('Request URL: $url');
      // print('Request Data: ${jsonEncode(customer)}');
      // print('api  :: 11');

      var response = await http.post(
        Uri.parse(urlApi),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(customer),
      );

      // print('api :: 22');

      // print('Response Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');

      return response;
    } catch (e) {
      print('Error Catch from api ($e)');
      return null;
    }
  }

  Future<List<Customer>> getCustomer(String urlApi) async {
    final url = Uri.parse(urlApi);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Customer.fromJson(item)).toList();
      } else {
        print('Failed to load customer. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

//? Edit

  Future<bool> updateCustomer(String url, Customer customer) async {
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('Token is null');
      }
      final response = await http.put(
        Uri.parse('$url?id=${customer.id}'),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
            customer.toJson()), // Ensure this matches your API's expectations
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Failed to update customer: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Update customer API error: $e');
      return false;
    }
  }

  Future<bool> deleteCustomer(String url, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$url/$id'),
      );
      if (response.statusCode == 204) {
        return true;
      } else {
        print('Failed to delete customer: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Delete customer API error: $e');
      return false;
    }
  }

  //! Supplier Servises

  Future<http.Response?> postSupplier(
      String urlApi, Map<String, dynamic> supplier) async {
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('Token is null');
      }
      // print('enter to api file');
      // print('Request URL: $url');
      // print('Request Data: ${jsonEncode(customer)}');
      // print('api  :: 11');

      var response = await http.post(
        Uri.parse(urlApi),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(supplier),
      );

      // print('api :: 22');

      // print('Response Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');

      return response;
    } catch (e) {
      print('Error Catch from api ($e)');
      return null;
    }
  }

  Future<List<Supplier>> getSupplier(String urlApi) async {
    final url = Uri.parse(urlApi);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Supplier.fromJson(item)).toList();
      } else {
        print('Failed to load supplier. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error lll: $e');
      return [];
    }
  }

  //? Edit
  Map<String, dynamic> supplierToApiJson(Supplier supplier) {
    return {
      "id": supplier.id,
      "name": supplier.name,
      "contact":
          supplier.contact.phoneNumber, // Adjust to match API expectation
    };
  }

  Future<bool> updateSupplier(String url, Supplier supplier) async {
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('Token is null');
      }
      final response = await http.put(
        Uri.parse('$url/${supplier.id}'),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(supplierToApiJson(
            supplier)), // Ensure this matches your API's expectations
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Failed to update supplier: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Update supplier API error: $e');
      return false;
    }
  }

  Future<bool> deleteSupplier(String url, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$url/$id'),
      );
      if (response.statusCode == 204) {
        return true;
      } else {
        print('Failed to delete supplier: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Delete supplier API error: $e');
      return false;
    }
  }

//! Roles

  Future<List<Role>> getRoles(String urlApi) async {
    final url = Uri.parse(urlApi);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Role.fromJson(item)).toList();
      } else {
        print('Failed to load roles. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // ! Orderas

  Future<http.Response?> postAddINboundOrder(
      String url, Map<String, dynamic> data) async {
    try {
      // Fetch token from secure storage
      String? token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found');
      }

      // Print the data being sent for debugging purposes
      print('Sending data: ${jsonEncode(data)}');

      // Make the POST request
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      // Print the response for debugging purposes
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      // Return the response
      return response;
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }

  Future<http.Response?> postAddOutboundOrder(
      String url, Map<String, dynamic> data) async {
    try {
      // Fetch token from secure storage
      String? token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found');
      }

      // Print the data being sent for debugging purposes
      print('Sending data: ${jsonEncode(data)}');

      // Make the POST request
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      // Print the response for debugging purposes
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      // Return the response
      return response;
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }

  Future<List<INboundOrder>> getINboundOrder() async {
    const url =
        'https://localhost:7086/api/po/ib_po'; // Replace with your actual API endpoint

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        // print('Response status: ${response.statusCode}');
        // print('Response body: ${response.body}');
        return jsonResponse.map((data) => INboundOrder.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load purchase  in orders');
      }
    } catch (e) {
      print('Error fetching in order: $e');
      throw e;
    }
  }

  Future<List<OutboundOrderModel>> getOutboundOrder() async {
    const url =
        'https://localhost:7086/api/po/in_po'; // Replace with your actual API endpoint

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        // print('Response status: ${response.statusCode}');
        // print('Response body: ${response.body}');
        return jsonResponse
            .map((data) => OutboundOrderModel.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load Out orders');
      }
    } catch (e) {
      print('Error fetching out orders: $e');
      throw e;
    }
  }

  //! delet and edit on in-order

  Future<bool> updateINorder(
      String url, Map<String, dynamic> requestData) async {
    try {
      final poNbr = requestData['poNbr'];
      String? token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('Token is null');
      }
      final response = await http.put(
        Uri.parse('$url/$poNbr'), // Assuming `poNbr` is in `requestData`
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestData),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Request Data: ${jsonEncode(requestData)}');

        print('$url/${requestData['poNbr']}');
        print('Failed to update order: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Update order API error: $e');
      return false;
    }
  }

  Future<bool> deleteINorder(String url, int id) async {
    try {
      final response = await http.delete(Uri.parse('$url/$id'));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Failed to update order: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting order: $e');
      return false;
    }
  }

  //! edit and delet for out order

  Future<bool> updateOUTorder(
      String url, Map<String, dynamic> requestData) async {
    try {
      final poNbr = requestData['poNbr'];
      String? token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('Token is null');
      }
      final response = await http.put(
        Uri.parse('$url/$poNbr'), // Assuming `poNbr` is in `requestData`
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestData),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Request Data: ${jsonEncode(requestData)}');

        print('$url/${requestData['poNbr']}');
        print('Failed to update order: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Update order API error: $e');
      return false;
    }
  }

  Future<bool> deleteOUTorder(String url, int id) async {
    try {
      final response = await http.delete(Uri.parse('$url$id'));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Failed to update order: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // ! Item
  Future<http.Response?> postAddItem(
      String url, Map<String, dynamic> data) async {
    try {
      // Fetch token from secure storage
      String? token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found');
      }

      // Print the data being sent for debugging purposes
      // print('Sending data: ${jsonEncode(data)}');

      // Make the POST request
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      // Print the response for debugging purposes
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Return the response
      return response;
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }

  // ! Master data
  Future<http.Response?> postAddMasterData(
      String url, Map<String, dynamic> data) async {
    try {
      // Fetch token from secure storage
      String? token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found');
      }

      // Print the data being sent for debugging purposes
      // print('Sending data: ${jsonEncode(data)}');

      // Make the POST request
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      // Print the response for debugging purposes
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      // Return the response
      return response;
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }
}
