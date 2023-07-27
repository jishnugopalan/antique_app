import 'dart:convert';

import 'package:antique_app/services/authservice.dart';
import 'package:antique_app/widgets/text_widgets.dart';
import 'package:antique_app/widgets/textbox_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class CustomerRegistration extends StatefulWidget {
  const CustomerRegistration({super.key});

  @override
  State<CustomerRegistration> createState() => _CustomerRegistrationState();
}

class _CustomerRegistrationState extends State<CustomerRegistration> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AuthService service = AuthService();
  bool _hidePassword1 = true;
  bool _hidePassword2 = true;
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length <= 2) {
      return 'Please enter a valid name';
    }
    return null;
  }

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  String? validatePhoneNumber(String? value) {
    String pattern = r'^[0-9]{10}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Enter valid phone number';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Password must have at least one uppercase, one lowercase, one number and one special character, and minimum 8 characters long.';
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(String? value) {
    String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Password must have at least one uppercase, one lowercase, one number and one special character, and minimum 8 characters long.';
    } else if (password.value != confirmpassword.value) {
      return 'Password not matching';
    } else {
      return null;
    }
  }

  showError(String content, String title) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  if (title == "Registration Successful") {
                    Navigator.pushNamed(context, '/login');
                  } else
                    Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<void> submitForm() async {
    var user = jsonEncode({
      "name": name.text,
      "email": email.text,
      "phone": phone.text,
      "passoword": password.text,
      "usertype": "customer",
    });
    print(user);
    try {
      final response = await service.registerUser(user);
      showError("Registration process completed", "Registration Successful");
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);

        showError(e.response!.data["msg"], "Registration Failed");
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        showError("Error occured,please try againlater", "Oops");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 30,
          ),
          const Center(
            child: HeadingText(
                text: "Customer Registration",
                align: TextAlign.center,
                color: Colors.deepPurple),
          ),
          const Center(
            child: SubHeadingText(
                text: "Create account",
                align: TextAlign.center,
                color: Colors.black),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(30),
            margin: const EdgeInsets.all(10),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextBox(
                      controller: name,
                      labelText: "Full name",
                      keyboardType: TextInputType.name,
                      prefixIcon: Icons.person,
                      validator: _validateName,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextBox(
                      controller: email,
                      labelText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.mail,
                      validator: validateEmail,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextBox(
                      controller: phone,
                      labelText: "Phone number",
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_android,
                      validator: validatePhoneNumber,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: password,
                      decoration: InputDecoration(
                        errorMaxLines: 200,
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_hidePassword1
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _hidePassword1 = !_hidePassword1;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      validator: validatePassword,
                      obscureText: _hidePassword1,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: confirmpassword,
                      decoration: InputDecoration(
                        errorMaxLines: 200,
                        labelText: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(_hidePassword2
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _hidePassword2 = !_hidePassword2;
                            });
                          },
                        ),
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      validator: validateConfirmPassword,
                      obscureText: _hidePassword2,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              submitForm();
                            }
                          },
                          child: const Text("Sign Up")),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextButton(
                        onPressed: () {
                          {
                            Navigator.pushNamed(context, '/login');
                          }
                        },
                        child: const DescriptionText(
                          align: TextAlign.left,
                          color: Colors.deepPurple,
                          text: 'Already have an account? Login',
                        ))
                  ],
                )),
          )
        ],
      ),
    );
  }
}
