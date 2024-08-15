import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/layout.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_web_dashboard/controllers/login_controllers.dart';

class Login extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white10,
        child: Center(
          child: Form(
            key: controller.loginFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              color: const Color.fromARGB(255, 225, 224, 224),
              height: 800,
              width: 1200,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 201, 200, 200)
                                  .withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Login to Your Account',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Color.fromARGB(255, 36, 171, 244),
                                  fontSize: 45,
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "User name",
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(100, 57, 138, 219),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                              ),
                              controller: controller.usernameController,
                              onSaved: (value) {
                                controller.username = value!;
                              },
                              validator: (value) {
                                return controller.validateUsername(value!);
                              },
                              style: TextStyle(
                                  fontSize:
                                      18), // Optional: Set a font size to ensure baseline calculations.
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Password",
                                prefixIcon: const Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(100, 57, 138, 219),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                              ),
                              controller: controller.passwordController,
                              onSaved: (value) {
                                controller.password = value!;
                              },
                              validator: (value) {
                                return controller.validatePassword(value!);
                              },
                              style: TextStyle(
                                  fontSize:
                                      18), // Optional: Set a font size to ensure baseline calculations.
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: 150, // Set the desired width
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 16, 125,
                                    214), // Set the default button color
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextButton(
                                onPressed: () {
                                  controller.checkLogin();
                                  // Get.to(SiteLayout());
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.hovered)) {
                                      return const Color.fromARGB(255, 25, 76,
                                          128); // Change button color when hovered
                                    }
                                    return Colors.blue; // Default button color
                                  }),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors
                                          .white), // Set button text color
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 50),
                            child: Container(
                              width: 1000,
                              height: 2000,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF64B5F6),
                                    Color(0xFF1976D2)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'WareWise',
                                    style: GoogleFonts.raleway(
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 60,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Welcome Admin',
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 234, 232, 232),
                                        fontSize: 35,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
