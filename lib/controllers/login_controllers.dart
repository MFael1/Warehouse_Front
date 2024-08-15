import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/constants/CustomLoadingIndicator.dart';
import 'package:flutter_web_dashboard/constants/SnackbarUtils.dart';
import 'package:flutter_web_dashboard/helpers/api.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_dashboard/layout.dart'; // Ensure the correct import for SiteLayout

class LoginController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  late TextEditingController usernameController, passwordController;

  var username = '';
  var password = '';
  var api = API();

  final storage = FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  String? validateUsername(String value) {
    if (value.isEmpty) {
      return "Provide a valid username";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.length < 3) {
      return "Password must be at least 8 characters long";
    }
    return null;
  }

  void checkLogin() {
    final isValid = loginFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    loginFormKey.currentState!.save();
    username = usernameController.text;
    password = passwordController.text;
    LoginFun();
  }

  // ignore: non_constant_identifier_names
  LoginFun() async {
    username = usernameController.text;
    password = passwordController.text;
    // ignore: prefer_const_declarations
    final url =
        'https://localhost:7086/api/user/login'; // Replace with your actual API endpoint
    final data = {
      'username': username,
      'password': password,
    };

    // Show loading indicator
    Get.dialog(
      CustomLoadingIndicator(),
      barrierDismissible: false, // Prevent dismissing dialog by tapping outside
    );

    try {
      print('login_controllers :: 11');
      var response = await api.postRequestLogin(url, data);
      print('login_controllers :: 22');
      // Dismiss loading indicator on successful response
      Get.back();

      if (response!.statusCode == 200 || response!.statusCode == 201) {
        Get.to(SiteLayout());
      } else {
        SnackbarUtils.showCustomSnackbar(
          title: 'warning',
          message: 'Your username or password is Wrong',
          backgroundColor: Color.fromARGB(255, 244, 54, 54),
        );
      }
    } catch (e) {
      print('Error Catch ($e)');
      Get.back(); // Dismiss loading indicator on error
      SnackbarUtils.showCustomSnackbar(
        title: 'Error',
        message: 'An error occurred. Please try again.',
        backgroundColor: Color.fromARGB(255, 34, 106, 248),
      );
    }
  }
}
