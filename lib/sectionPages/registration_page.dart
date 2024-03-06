import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flick_picks/HomePage/HomePage.dart';
import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/authservice.dart';
import 'login_page.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({Key? key});

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpassword = TextEditingController();
  AuthService service = AuthService();
  final _formKey = GlobalKey<FormState>();



  showError(BuildContext context, String content, String title) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) { // Explicitly specify the type here
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: Text("Ok"),
              onPressed: () {
                if (title == "Registration Successful") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );                } else {
                  Navigator.of(dialogContext).pop();
                }
              },
            )
          ],
        );
      },
    );
  }

  Future<void> signUserUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      BuildContext context = _formKey.currentContext!;

      var user = jsonEncode({
        "name": usernameController.text,
        "email": emailController.text,
        "phone": numberController.text,
        "password": passwordController.text,
        "usertype": "customer",
      });
      print(user);
      try {
        final response = await service.registerUser(user);
        showError(context,"Registration process completed", "Registration Successful");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } on DioException catch (e) {
        if (e.response != null) {
          print(e.response!.data);

          showError(context, e.response!.data["msg"], "Registration Failed");
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          showError(context, "Error occured,please try againlater", "Oops");
        }
      }
    }
  }










  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  const Icon(
                    Icons.lock,
                    size: 100,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Create an account',
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Username is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Email is required';
                      }
                      // You can add more specific email validation here if needed
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: numberController,
                    hintText: 'Phone Number',
                    obscureText: false,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Phone Number is required';
                      }
                      // You can add more specific phone number validation here if needed
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Password is required';
                      }
                      // You can add more specific password validation here if needed
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: confirmpassword,
                    hintText: 'Confirm Password',
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Confirm Password is required';
                      }
                      // You can add more specific validation for password match here if needed
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 25),
                  MyButton(
                    onTap: () => signUserUp(),
                    buttonName: "Sign Up",
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member?',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

