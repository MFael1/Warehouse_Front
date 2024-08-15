import 'dart:convert';
import 'package:flutter_web_dashboard/Model/Item.dart';
import 'package:flutter_web_dashboard/controllers/inbound_order_controller.dart';
import 'package:flutter_web_dashboard/controllers/item_master_controller.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<String?> getCurrentUserName() async {
    String urlapi = 'https://localhost:7086/api/User';

    final url = Uri.parse(urlapi);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Ensure 'username' is a string
        return data['username'] as String?;
      } else {
        print('Failed to load user data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  // Example method to fetch items
  Future<List<dynamic>> getItems() async {
    String urlapi = 'https://localhost:7086/api/Item/all';

    final url = Uri.parse(urlapi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<List<Item>> getItemsforitemsMaster() async {
    String urlapi = 'https://localhost:7086/api/Item/all';

    final url = Uri.parse(urlapi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Decode the JSON response
      final List<dynamic> data = jsonDecode(response.body);

      // Map the data to a list of Item objects
      List<Item> items = data.map((item) => Item.fromJson(item)).toList();

      return items;
    } else {
      print('Response code: ${response.statusCode}');
      print('Response body: ${response.body}');

      throw Exception('Failed to load items');
    }
  }
}
