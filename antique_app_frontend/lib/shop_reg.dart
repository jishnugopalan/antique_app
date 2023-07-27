import 'dart:convert';
import 'dart:io';

import 'package:antique_app/services/authservice.dart';
import 'package:antique_app/widgets/text_widgets.dart';
import 'package:antique_app/widgets/textbox_widget.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import 'package:image_picker/image_picker.dart';

class ShopRegistration extends StatefulWidget {
  const ShopRegistration({super.key});

  @override
  State<ShopRegistration> createState() => _ShopRegistrationState();
}

class _ShopRegistrationState extends State<ShopRegistration> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();

  final TextEditingController shopname = TextEditingController();
  final TextEditingController shopemail = TextEditingController();
  final TextEditingController shopnumber = TextEditingController();
  final TextEditingController shopcity = TextEditingController();
  final TextEditingController shoppincode = TextEditingController();

  final String license = "";
  String? district = "Alappuzha";
  final List<String> items = [
    'Alappuzha',
    'Ernakulam',
    'Idukki',
    'Kannur',
    'Kasaragod',
    'Kollam',
    'Kottayam',
    'Kozhikode',
    'Malappuram',
    'Palakkad',
    'Pathanamthitta',
    'Thiruvananthapuram',
    'Thrissur',
    'Wayanad'
  ];
  AuthService service = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _hidePassword1 = true;
  bool _hidePassword2 = true;
  XFile? _imageFile;
  bool isloading = false;
  Future<void> getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length <= 2) {
      return 'Please enter a valid name';
    }
    return null;
  }

  String? _validateShopName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your shop name';
    }
    if (value.length <= 2) {
      return 'Please enter a valid shop name';
    }
    return null;
  }

  String? _validateShopCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your shop city';
    }
    if (value.length <= 2) {
      return 'Please enter a valid shop city';
    }
    return null;
  }

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Enter valid email';
    } else {
      return null;
    }
  }

  String? validateShopEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Enter valid shop email';
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

  String? validateShopPhoneNumber(String? value) {
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

  String? validatePincode(String? value) {
    String pattern = r'^\d{6}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Enter a valid 6 digit number';
    } else {
      return null;
    }
  }

  //submit function
  Future<void> submitForm() async {
    setState(() {
      isloading = true;
    });
    List<String>? s = _imageFile?.path.toString().split("/");
    final bytes = await File(_imageFile!.path).readAsBytes();
    final base64 = base64Encode(bytes);
    var pic = "data:image/${s![s.length - 1].split(".")[1]};base64,$base64";
    var user = jsonEncode({
      "name": name.text,
      "email": email.text,
      "phone": phone.text,
      "password": password.text,
      "usertype": "shop",
      "shopname": shopname.text,
      "shopemail": shopemail.text,
      "shopphone": shopnumber.text,
      "shopcity": shopcity.text,
      "shopdistrict": district,
      "shoppincode": shoppincode.text,
      "shoplicense": pic
    });

    dev.log(user);
    try {
      final response = await service.registerUser(user);
      setState(() {
        isloading = false;
      });
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

  showError(String content, String title) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                child: const Text("Ok"),
                onPressed: () {
                  if (title == "Registration Successful") {
                    Navigator.pushNamed(context, '/login');
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Center(
                  child: HeadingText(
                      text: "Shop Registration",
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
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // const SubHeadingText(
                          //     text: 'Owner Details',
                          //     align: TextAlign.center,
                          //     color: Colors.deepPurple),
                          const SizedBox(
                            height: 15,
                          ),
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
                          // const SizedBox(
                          //   height: 15,
                          // ),
                          // const SubHeadingText(
                          //     text: "Shop Details",
                          //     align: TextAlign.center,
                          //     color: Colors.deepPurple),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextBox(
                            controller: shopname,
                            labelText: 'Shop Name',
                            keyboardType: TextInputType.name,
                            prefixIcon: Icons.shop,
                            validator: _validateShopName,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextBox(
                            controller: shopemail,
                            labelText: 'Shop Email',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.mark_email_read,
                            validator: validateShopEmail,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextBox(
                            controller: shopnumber,
                            labelText: 'Shop Phone Number',
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icons.phone,
                            validator: validateShopPhoneNumber,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextBox(
                            controller: shopcity,
                            labelText: 'Shop City',
                            prefixIcon: Icons.location_on,
                            validator: _validateShopCity,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                    isExpanded: true,
                                    hint: const Row(
                                      children: [
                                        Icon(
                                          Icons.list,
                                          size: 16,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Select District',
                                            style: TextStyle(
                                                //fontSize: 14,
                                                // fontWeight: FontWeight.bold,
                                                //color: Colors.black,
                                                ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    items: items
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ))
                                        .toList(),
                                    value: district,
                                    onChanged: (value) {
                                      //print(value);
                                      setState(() {
                                        district = value as String;
                                      });
                                    })),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextBox(
                            controller: shoppincode,
                            labelText: 'Pincode',
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icons.pin,
                            validator: validatePincode,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                              onTap: getImageFromGallery,
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30))),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    DescriptionText(
                                        text: "Upload License",
                                        align: TextAlign.center,
                                        color: Colors.black)
                                  ],
                                ),
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: _imageFile == null
                                ? const Text('No image selected ')
                                : Image.file(
                                    File(_imageFile!.path),
                                    width: 360,
                                    height: 240,
                                  ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  submitForm();
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
